import { unzipSync, strFromU8 } from "npm:fflate@0.8.2";
import { parse } from "npm:csv-parse@5.5.6/sync";
import { createClient } from "npm:@supabase/supabase-js@2.45.4";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Client-Info, Apikey",
};

const feedUrl = "https://files.mobilitydatabase.org/mdb-2200/mdb-2200-202411182003/mdb-2200-202411182003.zip";
const sourceUrl = "https://mobilitydatabase.org/feeds/gtfs/mdb-2200/map";
const datasetId = "mdb-2200-202411182003";
const importMode = "replace-truxdi-catalog-v2";
const importedAt = "2024-11-18T20:03:10.312Z";

type GtfsRoute = Record<string, string>;
type GtfsTrip = Record<string, string>;
type GtfsStop = Record<string, string>;
type GtfsStopTime = Record<string, string>;
type GtfsShapePoint = Record<string, string>;

type RouteRow = {
  id: string;
  code: string;
  name: string;
  color: string;
  direction: string;
  start_point: string;
  end_point: string;
  frequency_min: number;
  fare_soles: number;
  schedule: string;
  company: string;
  route_type: string;
  duration_min: number;
  slug: string;
  data_source: string;
  data_source_url: string;
  data_dataset_id: string;
  data_updated_at: string;
};

type StopRow = {
  id: string;
  route_id: string;
  name: string;
  lat: number;
  lng: number;
  order: number;
  is_major: boolean;
};

type SegmentRow = {
  id: string;
  route_id: string;
  lat: number;
  lng: number;
  order: number;
};

function readCsv(files: Record<string, Uint8Array>, name: string): Record<string, string>[] {
  const file = files[name];
  if (!file) throw new Error(`Missing GTFS file: ${name}`);
  return parse(strFromU8(file), { columns: true, skip_empty_lines: true, bom: true }) as Record<string, string>[];
}

function parseTime(value: string): number | null {
  const parts = value.split(":").map(Number);
  if (parts.length !== 3 || parts.some((part) => !Number.isFinite(part))) return null;
  return parts[0] * 60 + parts[1] + parts[2] / 60;
}

async function insertChunks<T>(table: string, rows: T[], client: ReturnType<typeof createClient>): Promise<void> {
  for (let index = 0; index < rows.length; index += 500) {
    const { error } = await client.from(table).insert(rows.slice(index, index + 500));
    if (error) throw new Error(`${table}: ${error.message}`);
  }
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response(null, { status: 200, headers: corsHeaders });

  try {
    if (req.method !== "POST") {
      return new Response(JSON.stringify({ error: "POST required" }), {
        status: 405,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    if (!supabaseUrl || !serviceRoleKey) throw new Error("Supabase service configuration is missing");

    const response = await fetch(feedUrl);
    if (!response.ok) throw new Error(`GTFS download failed with status ${response.status}`);
    const archive = unzipSync(new Uint8Array(await response.arrayBuffer()));
    const routes = readCsv(archive, "routes.txt") as GtfsRoute[];
    const agencies = new Map((readCsv(archive, "agency.txt") as GtfsRoute[]).map((row) => [row.agency_id, row.agency_name]));
    const trips = readCsv(archive, "trips.txt") as GtfsTrip[];
    const stops = new Map((readCsv(archive, "stops.txt") as GtfsStop[]).map((row) => [row.stop_id, row]));
    const stopTimes = readCsv(archive, "stop_times.txt") as GtfsStopTime[];
    const shapes = readCsv(archive, "shapes.txt") as GtfsShapePoint[];
    const fares = new Map((readCsv(archive, "fare_attributes.txt") as GtfsRoute[]).map((row) => [row.fare_id, Number(row.price)]));
    const fareByRoute = new Map<string, number>();
    for (const row of readCsv(archive, "fare_rules.txt") as GtfsRoute[]) {
      const fare = fares.get(row.fare_id);
      if (fare != null) fareByRoute.set(row.route_id, fare);
    }

    const tripByRoute = new Map<string, GtfsTrip>();
    for (const trip of trips) tripByRoute.set(trip.route_id, trip);
    const timesByTrip = new Map<string, GtfsStopTime[]>();
    for (const row of stopTimes) (timesByTrip.get(row.trip_id) ?? timesByTrip.set(row.trip_id, []).get(row.trip_id)!).push(row);
    const shapesByShape = new Map<string, GtfsShapePoint[]>();
    for (const point of shapes) (shapesByShape.get(point.shape_id) ?? shapesByShape.set(point.shape_id, []).get(point.shape_id)!).push(point);

    const routeRows: RouteRow[] = [];
    const stopRows: StopRow[] = [];
    const segmentRows: SegmentRow[] = [];

    for (const route of routes) {
      const id = crypto.randomUUID();
      const trip = tripByRoute.get(route.route_id);
      if (!trip) continue;
      const routeStops = (timesByTrip.get(trip.trip_id) ?? []).sort((a, b) => Number(a.stop_sequence) - Number(b.stop_sequence));
      const firstStop = stops.get(routeStops[0]?.stop_id);
      const lastStop = stops.get(routeStops[routeStops.length - 1]?.stop_id);
      const shapePoints = (shapesByShape.get(trip.shape_id) ?? []).sort((a, b) => Number(a.shape_pt_sequence) - Number(b.shape_pt_sequence));
      if (!firstStop || !lastStop || shapePoints.length < 2) continue;

      const times = routeStops.flatMap((stopTime) => [stopTime.arrival_time, stopTime.departure_time]).map(parseTime).filter((time): time is number => time != null);
      const duration = times.length > 1 ? Math.max(1, Math.round((Math.max(...times) - Math.min(...times)))) : 35;
      const code = route.route_short_name || route.route_id;
      const longName = route.route_long_name || code;
      const separator = longName.indexOf(" : ");
      const name = separator >= 0 ? longName.slice(separator + 3) : longName;
      const direction = firstStop.stop_name === lastStop.stop_name ? "Circular" : "Ida y vuelta";
      const slug = `tmt-${route.route_id}`;
      routeRows.push({
        id,
        code,
        name,
        color: route.route_color ? `#${route.route_color}` : "#2563eb",
        direction,
        start_point: firstStop.stop_name,
        end_point: lastStop.stop_name,
        frequency_min: 10,
        fare_soles: fareByRoute.get(route.route_id) ?? 2.5,
        schedule: "05:30 - 23:00",
        company: agencies.get(route.agency_id) ?? "TMT / Gerencia de Transporte",
        route_type: route.route_type === "3" ? "Bus" : "Micro",
        duration_min: duration,
        slug,
        data_source: "TMT / Gerencia de Transporte (GTFS)",
        data_source_url: sourceUrl,
        data_dataset_id: datasetId,
        data_updated_at: importedAt,
      });

      routeStops.forEach((stopTime, index) => {
        const stop = stops.get(stopTime.stop_id);
        if (!stop) return;
        stopRows.push({
          id: crypto.randomUUID(),
          route_id: id,
          name: stop.stop_name,
          lat: Number(stop.stop_lat),
          lng: Number(stop.stop_lon),
          order: index + 1,
          is_major: index === 0 || index === routeStops.length - 1,
        });
      });
      shapePoints.forEach((point, index) => {
        segmentRows.push({
          id: crypto.randomUUID(),
          route_id: id,
          lat: Number(point.shape_pt_lat),
          lng: Number(point.shape_pt_lon),
          order: index,
        });
      });
    }

    const client = createClient(supabaseUrl, serviceRoleKey);
    const { data: existingDataset, error: existingError } = await client
      .from("routes")
      .select("id")
      .eq("data_dataset_id", datasetId)
      .limit(1);
    if (existingError) throw new Error(`Existing dataset check: ${existingError.message}`);
    if (existingDataset && existingDataset.length > 0) {
      return new Response(JSON.stringify({ imported: false, datasetId, updatedAt: importedAt }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const { data: oldRoutes, error: oldRoutesError } = await client
      .from("routes")
      .select("id")
      .is("data_dataset_id", null);
    if (oldRoutesError) throw new Error(`Old catalog lookup: ${oldRoutesError.message}`);
    const oldRouteIds = (oldRoutes ?? []).map((row) => row.id as string);

    await insertChunks("routes", routeRows, client);
    await insertChunks("stops", stopRows, client);
    await insertChunks("route_segments", segmentRows, client);

    for (let index = 0; index < oldRouteIds.length; index += 500) {
      const ids = oldRouteIds.slice(index, index + 500);
      for (const table of ["stops", "route_segments"]) {
        const { error } = await client.from(table).delete().in("route_id", ids);
        if (error) throw new Error(`${table} cleanup: ${error.message}`);
      }
      const { error } = await client.from("routes").delete().in("id", ids);
      if (error) throw new Error(`routes cleanup: ${error.message}`);
    }

    return new Response(JSON.stringify({
      imported: { routes: routeRows.length, stops: stopRows.length, segments: segmentRows.length },
      source: "TMT / Gerencia de Transporte GTFS",
      datasetId,
      updatedAt: importedAt,
    }), { headers: { ...corsHeaders, "Content-Type": "application/json" } });
  } catch (error) {
    const message = error instanceof Error ? error.message : "GTFS import failed";
    return new Response(JSON.stringify({ error: message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
