// Importa un lote de rutas del GTFS de Trujillo (mdb-2200) al formato de
// catálogo de la aplicación. Reutiliza la misma transformación que
// import-pilot-route.mjs pero procesa múltiples route_ids y combina el
// resultado en un solo archivo.
//
// Uso:
//   node scripts/import-gtfs-batch.mjs <gtfs-dir> <out.json> <route_id> [<route_id> ...]
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

const [,, gtfsDir, outPath, ...routeIds] = process.argv;
if (!gtfsDir || !outPath || routeIds.length === 0) {
  console.error('Uso: node import-gtfs-batch.mjs <gtfs-dir> <out.json> <route_id> [...]');
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

const stopsById = new Map(stops.map((s) => [s.stop_id, s]));
const agencyMap = new Map(agencies.map((a) => [a.agency_id, a]));
const feedVersion = feedInfo?.feed_version || 'desconocida';
const feedStart = feedInfo?.feed_start_date || '';
const feedEnd = feedInfo?.feed_end_date || '';
const today = new Date().toISOString().slice(0, 10);

const catalogRoutes = [];
const catalogStops = [];
const stopIdsAdded = new Set();
const report = [];

for (const routeId of routeIds) {
  const route = routes.find((r) => r.route_id === routeId);
  if (!route) {
    report.push({ routeId, status: 'omitida', reason: 'route_id no encontrado en routes.txt' });
    continue;
  }
  const agency = agencyMap.get(route.agency_id);
  const trip = trips.find((t) => t.route_id === routeId);
  if (!trip) {
    report.push({ routeId, code: route.route_short_name, status: 'omitida', reason: 'sin trip' });
    continue;
  }

  const shapePts = shapes
    .filter((s) => s.shape_id === trip.shape_id)
    .sort((a, b) => Number(a.shape_pt_sequence) - Number(b.shape_pt_sequence));
  if (shapePts.length < 2) {
    report.push({ routeId, code: route.route_short_name, status: 'omitida', reason: 'sin geometría utilizable' });
    continue;
  }
  const coordinates = shapePts.map((p) => [Number(p.shape_pt_lon), Number(p.shape_pt_lat)]);

  const tripStopTimes = stopTimes
    .filter((st) => st.trip_id === trip.trip_id)
    .sort((a, b) => Number(a.stop_sequence) - Number(b.stop_sequence));

  const firstStopId = tripStopTimes[0]?.stop_id;
  const lastStopId = tripStopTimes[tripStopTimes.length - 1]?.stop_id;
  const firstStop = stopsById.get(firstStopId);
  const lastStop = stopsById.get(lastStopId);
  const isCircular = firstStop && lastStop && firstStop.stop_name === lastStop.stop_name;
  const direction = isCircular ? 'circular' : 'desconocido';

  const stopRefs = [];
  let realesCount = 0;
  let autoCount = 0;
  for (const st of tripStopTimes) {
    const s = stopsById.get(st.stop_id);
    if (!s) continue;
    if (s.stop_name === 'innominada') { autoCount++; continue; }
    const stopAppId = `osm-stop-${s.stop_id}`;
    if (!stopRefs.includes(stopAppId)) {
      stopRefs.push(stopAppId);
      realesCount++;
      if (!stopIdsAdded.has(stopAppId)) {
        stopIdsAdded.add(stopAppId);
        catalogStops.push({
          id: stopAppId,
          name: s.stop_name,
          coords: { lng: Number(s.stop_lon), lat: Number(s.stop_lat) },
          source: 'OpenStreetMap (vía GTFS Trufi/OMUS mdb-2200)',
          verificationStatus: 'pendiente',
        });
      }
    }
  }

  const longName = route.route_long_name || route.route_short_name || routeId;
  const sep = longName.indexOf(' : ');
  const name = sep >= 0 ? longName.slice(sep + 3) : longName;
  const arrowIdx = longName.indexOf(' → ');
  let origin, destination;
  if (arrowIdx >= 0) {
    const before = sep >= 0 ? longName.slice(sep + 3, arrowIdx) : longName.slice(0, arrowIdx);
    const after = longName.slice(arrowIdx + 3);
    origin = before.trim();
    destination = after.trim();
  }

  const fareRule = fareRules.find((fr) => fr.route_id === routeId);
  let fareRef = null;
  if (fareRule) {
    const fa = fareAttrs.find((f) => f.fare_id === fareRule.fare_id);
    if (fa) fareRef = { price: Number(fa.price), currency: fa.currency_type };
  }
  const freq = frequencies.find((f) => f.trip_id === trip.trip_id);

  catalogRoutes.push({
    id: `osm-route-${route.route_id}`,
    code: route.route_short_name || undefined,
    name,
    company: agency?.agency_name,
    mode: 'desconocida',
    color: route.route_color ? `#${route.route_color}` : '#2563eb',
    sources: [
      'OpenStreetMap (ODbL)',
      'GTFS Trufi/OMUS mdb-2200',
      'https://github.com/trufi-association/Trujillo-OMUS',
    ],
    verifiedAt: undefined,
    variants: [
      {
        id: `osm-route-${route.route_id}-v1`,
        label: direction === 'circular' ? 'Circular' : 'Variante 1',
        direction,
        origin,
        destination,
        geometry: { type: 'LineString', coordinates },
        stopRefs,
        geometryStatus: 'verificada',
      },
    ],
    _sourceMeta: {
      gtfsRouteId: route.route_id,
      gtfsFeedId: 'mdb-2200',
      gtfsFeedVersion: feedVersion,
      gtfsFeedUrl: 'https://files.mobilitydatabase.org/mdb-2200/mdb-2200-202411182003/mdb-2200-202411182003.zip',
      gtfsShapeId: trip.shape_id,
      gtfsTripId: trip.trip_id,
      osmRelationId: route.route_id,
      extractedAt: today,
      feedServiceRange: feedStart && feedEnd ? `${feedStart}–${feedEnd}` : undefined,
      fareRef: fareRef ?? undefined,
      frequencyHeadwaySec: freq ? Number(freq.headway_secs) : undefined,
      stopTimesTotal: tripStopTimes.length,
      stopsAutoGeneratedExcluded: autoCount,
    },
  });

  report.push({
    routeId,
    code: route.route_short_name,
    name,
    operator: agency?.agency_name,
    status: 'importada',
    shapePoints: coordinates.length,
    paraderosReales: realesCount,
    paradasAutoExcluidas: autoCount,
    direction,
  });
}

const catalog = { routes: catalogRoutes, stops: catalogStops };
writeFileSync(outPath, JSON.stringify(catalog, null, 2));

console.error(`\n=== Lote importado ===`);
console.error(`Rutas importadas: ${catalogRoutes.length}`);
console.error(`Paraderos únicos en catálogo: ${catalogStops.length}`);
console.error(`Rutas omitidas: ${routeIds.length - catalogRoutes.length}`);
for (const r of report) {
  if (r.status === 'importada') {
    console.error(`  ✓ ${r.code} | ${r.name} | ${r.operator} | ${r.shapePoints} pts | ${r.paraderosReales} paraderos | ${r.direction}`);
  } else {
    console.error(`  ✗ ${r.routeId} | ${r.status}: ${r.reason}`);
  }
}
