/*
# Repair CT-26 A stops after rotation: re-anchor to Jirón Rimac coords

1. Background
- The previous rotation migration rotated route_segments correctly (orders 0..339
  now start at Jirón Rimac's coordinate) but applied the segment-pivot index (178)
  directly to the stops table (only 25 rows), producing negative/incorrect stop
  orders and misaligned coordinates. The stops and segments no longer match.

2. Approach
- Delete all stops for this route and regenerate them by sampling the (now
  rotated) route_segments polyline in order:
    * stop #1 = first segment point = Jirón Rimac coords, is_major = true
    * stop #25 = last segment point = Jirón Rimac coords (circular), is_major = true
    * 23 intermediate stops evenly spaced along the polyline, named "Parada i".
- This guarantees every stop sits exactly on the rotated line and the loop
  starts/ends at Jirón Rimac, matching Truxdi.

3. Tables modified
- stops: rows deleted and re-inserted for this one route only.

4. Idempotency
- The DO block only runs if the route's stop at order 1 is not already named
  "Jirón Rimac" at the correct coordinates. Re-running is a no-op once fixed.
*/

DO $$
DECLARE
  rid uuid;
  pts double precision[];
  pts_lat double precision[];
  pts_lng double precision[];
  n int;
  target_count int := 23;       -- intermediate stops between the two endpoints
  i int;
  idx int;
  step float;
  lat_val double precision;
  lng_val double precision;
BEGIN
  SELECT id INTO rid FROM routes WHERE slug = 'ct-26-a-horizonte-ecologico-circular';
  IF rid IS NULL THEN
    RAISE NOTICE 'Route not found';
    RETURN;
  END IF;

  -- Already correct? skip.
  IF EXISTS (
    SELECT 1 FROM stops
    WHERE route_id = rid AND "order" = 1
      AND name = 'Jirón Rimac'
      AND ROUND(lat::numeric, 5) = -8.10614
      AND ROUND(lng::numeric, 5) = -79.02234
  ) THEN
    RAISE NOTICE 'Already fixed, skipping';
    RETURN;
  END IF;

  -- Gather rotated segment points in order
  SELECT array_agg(lat ORDER BY "order") INTO pts_lat
  FROM route_segments WHERE route_id = rid;
  SELECT array_agg(lng ORDER BY "order") INTO pts_lng
  FROM route_segments WHERE route_id = rid;

  n := array_length(pts_lat, 1);
  IF n < 2 THEN
    RAISE NOTICE 'Not enough segment points';
    RETURN;
  END IF;

  DELETE FROM stops WHERE route_id = rid;

  -- Endpoint 1: Jirón Rimac (start)
  INSERT INTO stops (id, route_id, name, lat, lng, "order", is_major, created_at)
  VALUES (gen_random_uuid(), rid, 'Jirón Rimac',
          pts_lat[1], pts_lng[1], 1, true, now());

  -- Intermediate stops evenly spaced along the rotated polyline
  FOR i IN 1..target_count LOOP
    step := i::float / (target_count + 1);
    idx := 1 + floor(step * (n - 1))::int;
    IF idx < 1 THEN idx := 1; END IF;
    IF idx > n THEN idx := n; END IF;
    lat_val := pts_lat[idx];
    lng_val := pts_lng[idx];
    IF NOT EXISTS (
      SELECT 1 FROM stops s2
      WHERE s2.route_id = rid AND s2.lat = lat_val AND s2.lng = lng_val
    ) THEN
      INSERT INTO stops (id, route_id, name, lat, lng, "order", is_major, created_at)
      VALUES (gen_random_uuid(), rid, 'Parada ' || (i + 1),
              lat_val, lng_val, i + 1, false, now());
    END IF;
  END LOOP;

  -- Endpoint 2: Jirón Rimac (end, circular)
  INSERT INTO stops (id, route_id, name, lat, lng, "order", is_major, created_at)
  VALUES (gen_random_uuid(), rid, 'Jirón Rimac',
          pts_lat[n], pts_lng[n], target_count + 2, true, now());

  RAISE NOTICE 'Re-anchored CT-26 A stops at Jirón Rimac';
END $$;
