-- Function to bulk insert route segments from JSON
-- SECURITY DEFINER bypasses RLS for the insert
CREATE OR REPLACE FUNCTION public.bulk_insert_route_segments(json_data json)
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  inserted_count integer;
BEGIN
  INSERT INTO route_segments (route_id, lat, lng, "order")
  SELECT
    (j->>'route_id')::uuid,
    (j->>'lat')::double precision,
    (j->>'lng')::double precision,
    (j->>'order')::integer
  FROM json_array_elements(json_data) AS j;
  
  GET DIAGNOSTICS inserted_count = ROW_COUNT;
  RETURN inserted_count;
END;
$$;

GRANT EXECUTE ON FUNCTION public.bulk_insert_route_segments(json) TO anon, authenticated;