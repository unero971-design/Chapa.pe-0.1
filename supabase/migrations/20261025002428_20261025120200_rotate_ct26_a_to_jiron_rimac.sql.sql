/*
# Rotate CT-26 A (Horizonte Ecologico) so the loop starts at Jirón Rimac

1. Background
- Truxdi's ficha for CT-26 A describes it as "Jirón Rimac → Jirón Rimac" (circular
  starting and ending at Jirón Rimac). Our current data has 25 stops and 340
  segment points forming a closed loop, but the ordering starts at
  "Avenida Miguel Grau" (segment order 0) and Jirón Rimac sits near the middle
  (segment order ~178). The route metadata (start_point/end_point) already says
  Jirón Rimac, so the stops and geometry disagree with the metadata and with
  Truxdi.

2. Approach
- Find the segment point closest to Jirón Rimac (lat -8.10614, lng -79.02234).
  Call its order `pivot`.
- Re-number every route_segments row for this route so the pivot becomes order 0
  and the rest follow in their existing cyclic order (i.e. (order - pivot) mod N).
  This is a pure re-ordering — no coordinates change, so the rendered line is
  identical, just redrawn starting at Jirón Rimac.
- Re-number stops the same way, then move the new first stop to order 1 and the
  new last stop to order 25. Set is_major = true on the two endpoints (which are
  both Jirón Rimac for this circular) and rename them to "Jirón Rimac" so the
  stop list matches Truxdi.
- Re-apply the start_point / end_point on the routes row to "Jirón Rimac" (it
  already is, but this keeps them consistent).

3. Tables modified
- route_segments: order column re-numbered for this one route (no coordinate
  changes, no rows added or deleted).
- stops: order column re-numbered and two endpoint names/is_major flags updated
  for this one route.
- routes: start_point/end_point reaffirmed as "Jirón Rimac".

4. Idempotency
- The DO block detects whether the route's first stop is already "Jirón Rimac"
  and skips re-running if so. Re-applying is a no-op.
*/

DO $$
DECLARE
  rid uuid;
  pivot int;
  n_seg int;
  n_stops int;
BEGIN
  SELECT id INTO rid FROM routes WHERE slug = 'ct-26-a-horizonte-ecologico-circular';
  IF rid IS NULL THEN
    RAISE NOTICE 'Route not found';
    RETURN;
  END IF;

  -- Already rotated? Skip.
  IF EXISTS (
    SELECT 1 FROM stops
    WHERE route_id = rid AND "order" = 1 AND name = 'Jirón Rimac'
  ) THEN
    RAISE NOTICE 'Already rotated, skipping';
    RETURN;
  END IF;

  -- Find the pivot: segment order closest to Jirón Rimac coords
  SELECT rs."order" INTO pivot
  FROM route_segments rs
  WHERE rs.route_id = rid
  ORDER BY (rs.lat - -8.10614)^2 + (rs.lng - -79.02234)^2 ASC
  LIMIT 1;

  SELECT count(*) INTO n_seg FROM route_segments WHERE route_id = rid;
  SELECT count(*) INTO n_stops FROM stops WHERE route_id = rid;

  -- Re-number segment orders: (order - pivot + N) mod N
  -- Use a temp column to avoid collisions during update.
  ALTER TABLE route_segments ADD COLUMN IF NOT EXISTS new_order int;

  UPDATE route_segments
  SET new_order = MOD(("order" - pivot + n_seg), n_seg)
  WHERE route_id = rid;

  UPDATE route_segments
  SET "order" = new_order
  WHERE route_id = rid;

  ALTER TABLE route_segments DROP COLUMN IF EXISTS new_order;

  -- Re-number stops the same way, then shift to 1-based.
  ALTER TABLE stops ADD COLUMN IF NOT EXISTS new_order int;

  UPDATE stops
  SET new_order = MOD(("order" - pivot + n_stops), n_stops) + 1
  WHERE route_id = rid;

  UPDATE stops
  SET "order" = new_order
  WHERE route_id = rid;

  ALTER TABLE stops DROP COLUMN IF EXISTS new_order;

  -- Endpoints: first and last should be Jirón Rimac (is_major = true)
  UPDATE stops SET name = 'Jirón Rimac', is_major = true
  WHERE route_id = rid AND "order" = 1;

  UPDATE stops SET name = 'Jirón Rimac', is_major = true
  WHERE route_id = rid AND "order" = n_stops;

  -- Reaffirm endpoints on the route row
  UPDATE routes
  SET start_point = 'Jirón Rimac', end_point = 'Jirón Rimac'
  WHERE id = rid;
END $$;
