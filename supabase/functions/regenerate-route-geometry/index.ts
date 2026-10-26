import { createClient } from "npm:@supabase/supabase-js@2";
import { corsHeaders } from "../_shared/cors.ts";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const OSRM_BASE = "https://router.project-osrm.org/route/v1/driving";

interface Stop {
  id: string;
  name: string;
  lat: number;
  lng: number;
  order: number;
}

interface Route {
  id: string;
  slug: string;
  code: string;
  name: string;
}

interface OsrmRoute {
  geometry: {
    coordinates: [number, number][];
  };
}

interface OsrmResponse {
  routes: OsrmRoute[];
  code: string;
  message?: string;
}

async function fetchOsrmRoute(
  startLng: number,
  startLat: number,
  endLng: number,
  endLat: number,
): Promise<[number, number][]> {
  const url = `${OSRM_BASE}/${startLng},${startLat};${endLng},${endLat}?overview=full&geometries=geojson`;
  const resp = await fetch(url);
  if (!resp.ok) {
    throw new Error(`OSRM HTTP ${resp.status}`);
  }
  const data: OsrmResponse = await resp.json();
  if (!data.routes || data.routes.length === 0) {
    throw new Error(`OSRM no route: ${data.code} ${data.message ?? ""}`);
  }
  return data.routes[0].geometry.coordinates.map(([lng, lat]) => [lat, lng]);
}

async function processRoute(
  supabase: ReturnType<typeof createClient>,
  route: Route,
): Promise<{ slug: string; code: string; pointsAdded: number; error?: string }> {
  const { data: stops, error: stopsError } = await supabase
    .from("stops")
    .select("id, name, lat, lng, order")
    .eq("route_id", route.id)
    .order("order") as { data: Stop[] | null; error: { message: string } | null };

  if (stopsError) {
    return { slug: route.slug, code: route.code, pointsAdded: 0, error: stopsError.message };
  }
  if (!stops || stops.length < 2) {
    return { slug: route.slug, code: route.code, pointsAdded: 0, error: "Not enough stops" };
  }

  const allCoords: { lat: number; lng: number; order: number }[] = [];
  let orderCounter = 0;

  for (let i = 0; i < stops.length - 1; i++) {
    const a = stops[i];
    const b = stops[i + 1];
    try {
      const coords = await fetchOsrmRoute(a.lng, a.lat, b.lng, b.lat);
      for (const [lat, lng] of coords) {
        allCoords.push({ lat, lng, order: orderCounter++ });
      }
    } catch (err) {
      const e = err as Error;
      console.error(`OSRM failed for ${route.slug} segment ${i}: ${e.message}`);
      allCoords.push({ lat: a.lat, lng: a.lng, order: orderCounter++ });
      allCoords.push({ lat: b.lat, lng: b.lng, order: orderCounter++ });
    }
  }

  const { error: delError } = await supabase
    .from("route_segments")
    .delete()
    .eq("route_id", route.id);

  if (delError) {
    return { slug: route.slug, code: route.code, pointsAdded: 0, error: delError.message };
  }

  const insertData = allCoords.map((c) => ({
    route_id: route.id,
    lat: c.lat,
    lng: c.lng,
    order: c.order,
  }));

  const BATCH_SIZE = 500;
  for (let i = 0; i < insertData.length; i += BATCH_SIZE) {
    const batch = insertData.slice(i, i + BATCH_SIZE);
    const { error: insError } = await supabase
      .from("route_segments")
      .insert(batch);
    if (insError) {
      return { slug: route.slug, code: route.code, pointsAdded: i, error: insError.message };
    }
  }

  return { slug: route.slug, code: route.code, pointsAdded: allCoords.length };
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 200, headers: corsHeaders });
  }

  try {
    const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

    const url = new URL(req.url);
    const slugParam = url.searchParams.get("slug");
    const limitParam = url.searchParams.get("limit");
    const offsetParam = url.searchParams.get("offset");

    let routeQuery = supabase.from("routes").select("id, slug, code, name").order("slug");
    if (slugParam) {
      routeQuery = routeQuery.eq("slug", slugParam);
    }
    if (limitParam) {
      routeQuery = routeQuery.limit(parseInt(limitParam, 10));
    }
    if (offsetParam) {
      routeQuery = routeQuery.range(
        parseInt(offsetParam, 10),
        parseInt(offsetParam, 10) + (limitParam ? parseInt(limitParam, 10) - 1 : 9999),
      );
    }

    const { data: routes, error: routesError } = await routeQuery as {
      data: Route[] | null;
      error: { message: string } | null;
    };

    if (routesError) {
      return new Response(
        JSON.stringify({ error: routesError.message }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    if (!routes || routes.length === 0) {
      return new Response(
        JSON.stringify({ error: "No routes found" }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    const results: Array<{ slug: string; code: string; pointsAdded: number; error?: string }> = [];
    for (const route of routes) {
      console.log(`Processing ${route.slug} (${route.code})...`);
      const result = await processRoute(supabase, route);
      results.push(result);
      await new Promise((resolve) => setTimeout(resolve, 200));
    }

    const succeeded = results.filter((r) => !r.error).length;
    const failed = results.filter((r) => r.error);

    return new Response(
      JSON.stringify({
        total: routes.length,
        succeeded,
        failed: failed.length,
        results,
      }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  } catch (err) {
    const e = err as Error;
    return new Response(
      JSON.stringify({ error: e.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }
});
