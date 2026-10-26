#!/usr/bin/env node
// Transforma UNA ruta del GTFS de Trujillo (mdb-2200) al formato de catálogo
// de la aplicación. Datos de origen: OpenStreetMap vía Trufi/OMUS.
//
// Uso:
//   node scripts/import-pilot-route.mjs <ruta-al-gtfs-extraido> <route_id> > <salida.json>
//
// El GTFS debe estar extraído (carpeta con routes.txt, trips.txt, shapes.txt,
// stops.txt, stop_times.txt, agency.txt, fare_rules.txt, fare_attributes.txt,
// frequencies.txt, feed_info.txt).
//
// Salida: JSON en stdout con el catálogo { routes, stops } listo para importar
// vía useTransportStore.importCatalog().
//
// Licencia de datos: OpenStreetMap (ODbL). Atribución requerida.
// Licencia del código generador: GPL-3.0 (Trujillo-OMUS).

import { readFileSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';

function readCsv(path) {
  const text = readFileSync(path, 'utf8').replace(/^\uFEFF/, '');
  const lines = text.split(/\r?\n/).filter((l) => l.length > 0);
  if (lines.length < 2) return [];
  const headers = lines[0].split(',');
  return lines.slice(1).map((line) => {
    const vals = line.split(',');
    const row = {};
    headers.forEach((h, i) => (row[h] = vals[i] ?? ''));
    return row;
  });
}

const gtfsDir = process.argv[2];
const routeId = process.argv[3];
const outPath = process.argv[4];

if (!gtfsDir || !routeId) {
  console.error('Uso: node import-pilot-route.mjs <gtfs-dir> <route_id> [out.json]');
  process.exit(1);
}

const routes = readCsv(join(gtfsDir, 'routes.txt'));
const trips = readCsv(join(gtfsDir, 'trips.txt'));
const shapes = readCsv(join(gtfsDir, 'shapes.txt'));
const stops = readCsv(join(gtfsDir, 'stops.txt'));
const stopTimes = readCsv(join(gtfsDir, 'stop_times.txt'));
const agencies = readCsv(join(gtfsDir, 'agency.txt'));
const fareRules = readCsv(join(gtfsDir, 'fare_rules.txt'));
const fareAttrs = readCsv(join(gtfsDir, 'fare_attributes.txt'));
const frequencies = readCsv(join(gtfsDir, 'frequencies.txt'));
const feedInfo = readCsv(join(gtfsDir, 'feed_info.txt'))[0];

const route = routes.find((r) => r.route_id === routeId);
if (!route) {
  console.error(`Ruta ${routeId} no encontrada en routes.txt`);
  process.exit(2);
}

const agency = agencies.find((a) => a.agency_id === route.agency_id);
const trip = trips.find((t) => t.route_id === routeId);
if (!trip) {
  console.error(`No hay trip para la ruta ${routeId}`);
  process.exit(3);
}

// Geometría: ordenar por shape_pt_sequence. Coordenadas [lng, lat].
const shapePts = shapes
  .filter((s) => s.shape_id === trip.shape_id)
  .sort((a, b) => Number(a.shape_pt_sequence) - Number(b.shape_pt_sequence));
if (shapePts.length < 2) {
  console.error(`Shape ${trip.shape_id} con menos de 2 puntos`);
  process.exit(4);
}
const coordinates = shapePts.map((p) => [
  Number(p.shape_pt_lon),
  Number(p.shape_pt_lat),
]);

// Paradas del trip, ordenadas por stop_sequence.
const tripStopTimes = stopTimes
  .filter((st) => st.trip_id === trip.trip_id)
  .sort((a, b) => Number(a.stop_sequence) - Number(b.stop_sequence));

// Detectar si es circular: primera y última parada iguales.
const firstStopId = tripStopTimes[0]?.stop_id;
const lastStopId = tripStopTimes[tripStopTimes.length - 1]?.stop_id;
const firstStop = stops.find((s) => s.stop_id === firstStopId);
const lastStop = stops.find((s) => s.stop_id === lastStopId);
const isCircular =
  firstStop && lastStop && firstStop.stop_name === lastStop.stop_name;

// direction_id no existe en este feed; usamos 'circular' o 'desconocido'.
const direction = isCircular ? 'circular' : 'desconocido';

// Paraderos: solo los que tienen nombre real (no "innominada").
// Los "innominada" son paradas auto-generadas a 100m (fakestops del GTFS).
const stopIds = tripStopTimes.map((st) => st.stop_id);
const stopOrder = new Map();
tripStopTimes.forEach((st, i) => stopOrder.set(st.stop_id, i));

const catalogStops = [];
const stopRefs = [];
for (const sid of stopIds) {
  const s = stops.find((x) => x.stop_id === sid);
  if (!s) continue;
  if (s.stop_name === 'innominada') continue; // auto-generada, no paradero real
  const stopAppId = `osm-stop-${s.stop_id}`;
  if (!stopRefs.includes(stopAppId)) {
    stopRefs.push(stopAppId);
    catalogStops.push({
      id: stopAppId,
      name: s.stop_name,
      coords: { lng: Number(s.stop_lon), lat: Number(s.stop_lat) },
      source: 'OpenStreetMap (vía GTFS Trufi/OMUS mdb-2200)',
      verificationStatus: 'pendiente',
    });
  }
}

// Nombre legible: extraer la parte después de " : " del long_name.
const longName = route.route_long_name || route.route_short_name || routeId;
const sep = longName.indexOf(' : ');
const name = sep >= 0 ? longName.slice(sep + 3) : longName;

// Origen/destino desde el long_name si tiene formato "A → B".
const arrowIdx = longName.indexOf(' → ');
let origin = undefined;
let destination = undefined;
if (arrowIdx >= 0) {
  const before = sep >= 0 ? longName.slice(sep + 3, arrowIdx) : longName.slice(0, arrowIdx);
  const after = longName.slice(arrowIdx + 3);
  origin = before.trim();
  destination = after.trim();
}

// Tarifa (no la mostramos como confirmada; la guardamos solo como referencia).
const fareRule = fareRules.find((fr) => fr.route_id === routeId);
let fareRef = null;
if (fareRule) {
  const fa = fareAttrs.find((f) => f.fare_id === fareRule.fare_id);
  if (fa) fareRef = { price: Number(fa.price), currency: fa.currency_type };
}

// Frecuencia (referencial).
const freq = frequencies.find((f) => f.trip_id === trip.trip_id);

// Metadata de origen.
const feedVersion = feedInfo?.feed_version || 'desconocida';
const feedStart = feedInfo?.feed_start_date || '';
const feedEnd = feedInfo?.feed_end_date || '';

const today = new Date().toISOString().slice(0, 10);

const catalog = {
  routes: [
    {
      id: `osm-route-${route.route_id}`,
      code: route.route_short_name || undefined,
      name,
      company: agency?.agency_name,
      mode: 'desconocida', // OSM no distingue micro/combi
      color: route.route_color ? `#${route.route_color}` : '#2563eb',
      sources: [
        'OpenStreetMap (ODbL)',
        'GTFS Trufi/OMUS mdb-2200',
        'https://github.com/trufi-association/Trujillo-OMUS',
      ],
      verifiedAt: undefined, // no confundir fecha de descarga con verificación
      variants: [
        {
          id: `osm-route-${route.route_id}-v1`,
          label: direction === 'circular' ? 'Circular' : 'Recorrido',
          direction,
          origin,
          destination,
          geometry: {
            type: 'LineString',
            coordinates,
          },
          stopRefs,
          geometryStatus: 'verificada', // geometría de OSM, trazada sobre vías
        },
      ],
      // Campos extra de referencia (no parte del modelo canónico, pero útiles
      // para auditoría). El validador los ignora si se omite .strict().
      _sourceMeta: {
        gtfsRouteId: route.route_id,
        gtfsFeedId: 'mdb-2200',
        gtfsFeedVersion: feedVersion,
        gtfsFeedUrl:
          'https://files.mobilitydatabase.org/mdb-2200/mdb-2200-202411182003/mdb-2200-202411182003.zip',
        gtfsShapeId: trip.shape_id,
        gtfsTripId: trip.trip_id,
        osmRelationId: route.route_id, // route_id en este feed = OSM relation id
        extractedAt: today,
        feedServiceRange: feedStart && feedEnd ? `${feedStart}–${feedEnd}` : undefined,
        fareRef: fareRef ?? undefined,
        frequencyHeadwaySec: freq ? Number(freq.headway_secs) : undefined,
        stopTimesTotal: tripStopTimes.length,
        stopsAutoGeneratedExcluded: tripStopTimes.length - stopRefs.length,
        notes:
          'Geometría y paradas derivadas de OpenStreetMap. Las paradas "innominada" del GTFS (auto-generadas a 100m) se excluyeron. Las paradas con nombre real son nodos OSM y NO han sido verificadas en campo como paraderos oficiales.',
      },
    },
  ],
  stops: catalogStops,
};

const output = JSON.stringify(catalog, null, 2);
if (outPath) {
  writeFileSync(outPath, output);
  console.error(`Escrito: ${outPath}`);
  console.error(`Ruta: ${catalog.routes[0].code} ${catalog.routes[0].name}`);
  console.error(`Geometría: ${coordinates.length} puntos`);
  console.error(`Paraderos: ${stopRefs.length} (con nombre real OSM)`);
  console.error(
    `Excluidos: ${tripStopTimes.length - stopRefs.length} (auto-generados "innominada")`,
  );
} else {
  process.stdout.write(output);
}
