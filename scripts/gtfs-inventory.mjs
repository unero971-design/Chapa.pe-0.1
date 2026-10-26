// Genera un inventario CSV de todas las rutas del GTFS de Trujillo.
// Uso: node scripts/gtfs-inventory.mjs <gtfs-dir> > inventario.csv

import { readFileSync } from 'node:fs';
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

const dir = process.argv[2];
if (!dir) {
  console.error('Uso: node gtfs-inventory.mjs <gtfs-dir>');
  process.exit(1);
}

const routes = readCsv(join(dir, 'routes.txt'));
const trips = readCsv(join(dir, 'trips.txt'));
const shapes = readCsv(join(dir, 'shapes.txt'));
const stops = readCsv(join(dir, 'stops.txt'));
const stopTimes = readCsv(join(dir, 'stop_times.txt'));
const agencies = readCsv(join(dir, 'agency.txt'));

// Indexar
const agencyMap = new Map(agencies.map((a) => [a.agency_id, a.agency_name]));
const tripOfRoute = new Map(trips.map((t) => [t.route_id, t]));
const shapePtCount = new Map();
for (const s of shapes) {
  shapePtCount.set(s.shape_id, (shapePtCount.get(s.shape_id) ?? 0) + 1);
}
const stopTimesByTrip = new Map();
for (const st of stopTimes) {
  stopTimesByTrip.set(st.trip_id, (stopTimesByTrip.get(st.trip_id) ?? 0) + 1);
}
const stopNameMap = new Map(stops.map((s) => [s.stop_id, s.stop_name]));

// Encabezado
const cols = [
  'route_id', 'codigo', 'nombre', 'operador',
  'puntos_shape', 'paradas_total', 'paraderos_reales',
  'estado', 'advertencia',
];
console.log(cols.join('|'));

let conGeo = 0;
let sinGeo = 0;

for (const r of routes) {
  const trip = tripOfRoute.get(r.route_id);
  const pts = trip ? (shapePtCount.get(trip.shape_id) ?? 0) : 0;
  const totalStops = trip ? (stopTimesByTrip.get(trip.trip_id) ?? 0) : 0;

  // Paraderos reales (no "innominada")
  let reales = 0;
  if (trip) {
    const tripST = stopTimes
      .filter((st) => st.trip_id === trip.trip_id)
      .sort((a, b) => Number(a.stop_sequence) - Number(b.stop_sequence));
    const seen = new Set();
    for (const st of tripST) {
      const name = stopNameMap.get(st.stop_id);
      if (name && name !== 'innominada' && !seen.has(st.stop_id)) {
        reales++;
        seen.add(st.stop_id);
      }
    }
  }

  const estado = pts >= 2 ? 'importar' : 'sin_geometria';
  if (pts >= 2) conGeo++; else sinGeo++;

  let adv = '';
  if (pts < 2) adv = 'sin_geometria_utilizable';
  else if (reales === 0) adv = 'sin_paraderos_reales';
  if (totalStops - reales > 0) {
    adv += (adv ? ';' : '') + `${totalStops - reales}_paradas_auto_generadas`;
  }

  const nombre = r.route_long_name || '';
  const op = agencyMap.get(r.agency_id) || '';
  console.log([
    r.route_id, r.route_short_name, nombre, op,
    pts, totalStops, reales, estado, adv,
  ].join('|'));
}

console.error(`Total rutas: ${routes.length}`);
console.error(`Con geometria utilizable: ${conGeo}`);
console.error(`Sin geometria: ${sinGeo}`);
console.error(`Shapes unicas: ${shapePtCount.size}`);
console.error(`Shapes referenciadas por trips: ${trips.length}`);
