/*
# Fix fake placeholder stops by sampling real points from segment geometry

1. Background
- 109 of 125 routes currently have fake placeholder stops ("Paradero 2".."Paradero 5")
  whose coordinates were generated artificially (lat + (ord-1)*0.0025) and do NOT lie
  on the actual route line. The route_segments table, however, holds the real OSM
  street geometry for these routes. This mismatch makes stops render floating in
  the ocean / off the road on the map.
- The remaining 14 routes already have real, properly named stops and must be left
  untouched. The 2 OSM-only routes (slug prefix osm-...) have no segments either and
  are handled in a separate migration.

2. Approach
- For every route that still has any stop whose name starts with 'Paradero ',
  delete ALL of that route's stops and regenerate them by sampling points along
  the route's existing route_segments polyline:
    * stop #1 = first segment point, named from routes.start_point, is_major = true
    * stop #N = last segment point, named from routes.end_point, is_major = true
    * intermediate stops are evenly spaced along the ordered segment points
      (up to 8 of them), named "Parada <i>" — a neutral, honest label rather than
      a fake place name we cannot verify.
- Coordinates come straight from route_segments, so every stop sits exactly on
  the rendered line.

3. Tables modified
- stops: rows deleted and re-inserted for the affected routes only.
- No schema changes. RLS / grants unchanged.

4. Idempotency
- The PL/pgSQL block only touches routes that still contain 'Paradero %' stops,
  so re-running is a no-op once a route has been fixed.
*/

DO $$
DECLARE
  r RECORD;
  seg_points RECORD;
  pts double precision[][];
  n int;
  step float;
  target_count int := 8;          -- max intermediate stops between the two endpoints
  i int;
  idx int;
  lat_val double precision;
  lng_val double precision;
  stop_order int;
BEGIN
  FOR r IN
    SELECT DISTINCT rt.id, rt.slug, rt.name, rt.start_point, rt.end_point
    FROM routes rt
    JOIN stops s ON s.route_id = rt.id
    WHERE s.name LIKE 'Paradero %'
  LOOP
    -- Collect the ordered geometry for this route into an array
    SELECT array_agg(ARRAY[seg.lat, seg.lng] ORDER BY seg."order")
      INTO pts
    FROM route_segments seg
    WHERE seg.route_id = r.id;

    IF pts IS NULL OR array_length(pts, 1) < 2 THEN
      RAISE NOTICE 'Skipping %: not enough segment points', r.slug;
      CONTINUE;
    END IF;

    n := array_length(pts, 1);

    -- Remove the fake stops for this route
    DELETE FROM stops WHERE route_id = r.id;

    -- Endpoint 1: start
    INSERT INTO stops (id, route_id, name, lat, lng, "order", is_major, created_at)
    VALUES (gen_random_uuid(), r.id, COALESCE(r.start_point, r.name),
            pts[1][1], pts[1][2], 1, true, now());

    -- Intermediate stops evenly spaced along the polyline
    FOR i IN 1..target_count LOOP
      step := i::float / (target_count + 1);
      idx := 1 + floor(step * (n - 1))::int;
      IF idx < 1 THEN idx := 1; END IF;
      IF idx > n THEN idx := n; END IF;
      lat_val := pts[idx][1];
      lng_val := pts[idx][2];

      -- Avoid placing two consecutive stops on the exact same coordinate
      IF NOT EXISTS (
        SELECT 1 FROM stops s2
        WHERE s2.route_id = r.id
          AND s2.lat = lat_val AND s2.lng = lng_val
      ) THEN
        INSERT INTO stops (id, route_id, name, lat, lng, "order", is_major, created_at)
        VALUES (gen_random_uuid(), r.id, 'Parada ' || (i + 1),
                lat_val, lng_val, i + 1, false, now());
      END IF;
    END LOOP;

    -- Endpoint 2: end
    INSERT INTO stops (id, route_id, name, lat, lng, "order", is_major, created_at)
    VALUES (gen_random_uuid(), r.id, COALESCE(r.end_point, r.name),
            pts[n][1], pts[n][2], target_count + 2, true, now());

    RAISE NOTICE 'Fixed %: % stops', r.slug, (SELECT count(*) FROM stops WHERE route_id = r.id);
  END LOOP;
END $$;
