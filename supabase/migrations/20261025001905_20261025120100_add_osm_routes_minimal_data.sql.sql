/*
# Add minimal stops + segment line for the 2 OSM-only routes

1. Background
- Two routes (slug prefix osm-) were added to reach the 125-route target but were
  never given stops or route_segments. They render as empty rows and cannot be
  drawn on the map.
- We add minimal stops (start + end, both is_major = true) and a straight segment
  line so the routes are visible/selectable. A coarse approximation to be refined
  later when real OSM geometry is available.

2. Tables modified
- stops: 2 new rows per route (start + end), is_major = true.
- route_segments: 21 interpolated points per route so the polyline renders.
- No schema changes. RLS / grants unchanged.

3. Idempotency
- The DO block only inserts when the route currently has zero stops, so re-running
  is a no-op once data exists.
*/

DO $$
DECLARE
  r RECORD;
  start_lat double precision;
  start_lng double precision;
  end_lat double precision;
  end_lng double precision;
  n int := 20;
  i int;
  lat_val double precision;
  lng_val double precision;
BEGIN
  FOR r IN
    SELECT id, slug, name, start_point, end_point
    FROM routes
    WHERE slug IN (
      'osm-19934524-operador-no-identificado-sentido',
      'osm-19970876-operador-no-identificado-sentido'
    )
  LOOP
    IF EXISTS (SELECT 1 FROM stops WHERE route_id = r.id) THEN
      RAISE NOTICE 'Skipping %: already has stops', r.slug;
      CONTINUE;
    END IF;

    IF r.slug = 'osm-19934524-operador-no-identificado-sentido' THEN
      start_lat := -8.11720; start_lng := -79.02900;
      end_lat   := -8.11090; end_lng   := -79.03610;
    ELSE
      start_lat := -8.11500; start_lng := -79.02400;
      end_lat   := -8.12000; end_lng   := -79.03000;
    END IF;

    INSERT INTO stops (id, route_id, name, lat, lng, "order", is_major, created_at)
    VALUES (gen_random_uuid(), r.id, COALESCE(r.start_point, r.name),
            start_lat, start_lng, 1, true, now());

    INSERT INTO stops (id, route_id, name, lat, lng, "order", is_major, created_at)
    VALUES (gen_random_uuid(), r.id, COALESCE(r.end_point, r.name),
            end_lat, end_lng, 2, true, now());

    FOR i IN 0..n LOOP
      lat_val := start_lat + (end_lat - start_lat) * (i::float / n);
      lng_val := start_lng + (end_lng - start_lng) * (i::float / n);
      INSERT INTO route_segments (id, route_id, lat, lng, "order")
      VALUES (gen_random_uuid(), r.id, lat_val, lng_val, i);
    END LOOP;

    RAISE NOTICE 'Added stops + segments for %', r.slug;
  END LOOP;
END $$;
