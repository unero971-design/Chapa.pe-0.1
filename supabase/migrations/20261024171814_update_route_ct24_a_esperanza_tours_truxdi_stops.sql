/*
# Update Route CT-24 A de Esperanza Tours (r007) with real Truxdi stops

## Summary
Replaces the 6 generic placeholder stops for route "CT-24 A de Esperanza Tours"
(r007) with 12 real highlighted stops sourced from the official Truxdi.com
route card (ficha).

## Data Source
- Truxdi: https://truxdi.com/trujillo/rutas/ct-24-a-esperanza-tours-circular
- 24 total paradas, 12 destacadas (highlighted)
- Route is circular (Sentido Circular): Jirón Rimac → Jirón Rimac
- Operated by Esperanza Tours S.R.L.
- Pasaje: S/. 2.00, Duration: 35 min
- Connects Avenida Miguel Grau and Avenida José Gabriel Condorcanqui

## Changes
1. Route r007 (6d6cb438-9e70-4ada-a65e-a9302c49766a):
   - Update start_point to "Avenida Miguel Grau"
   - Update end_point to "Avenida José Gabriel Condorcanqui, La Esperanza"

2. Stops table:
   - DELETE all existing placeholder stops for route r007
   - INSERT 12 real highlighted stops with coordinates snapped to the
     existing OSM route_segments geometry, ordered along the circular route
   - All 12 stops are the "destacadas" from the Truxdi ficha
   - All stops marked is_major = true (principal paraderos)

3. Route segments cleanup:
   - DELETE 6 duplicate old placeholder segments (orders 1-6 with
     approximate placeholder coordinates like -8.13, -79.035)
     that were not removed by the previous OSM geometry migration
   - The 201 OSM-based segments remain untouched

## Security
- No RLS policy changes (existing public read policies remain in effect)
- No new tables or columns
*/

-- 1. Update route r007 endpoints with real terminal names
UPDATE routes
SET start_point = 'Avenida Miguel Grau',
    end_point = 'Avenida José Gabriel Condorcanqui, La Esperanza'
WHERE id = '6d6cb438-9e70-4ada-a65e-a9302c49766a';

-- 2. Delete old placeholder stops for route r007
DELETE FROM stops
WHERE route_id = '6d6cb438-9e70-4ada-a65e-a9302c49766a';

-- 3. Delete old duplicate placeholder segments (6 rows with rounded coords)
DELETE FROM route_segments
WHERE route_id = '6d6cb438-9e70-4ada-a65e-a9302c49766a'
  AND lat IN (-8.13, -8.1275, -8.125, -8.1375, -8.14, -8.1425);

-- 4. Insert real Truxdi highlighted stops snapped to OSM geometry
INSERT INTO stops (route_id, name, lat, lng, "order", is_major)
VALUES
  ('6d6cb438-9e70-4ada-a65e-a9302c49766a', 'Avenida Miguel Grau', -8.04901, -79.056839, 1, true),
  ('6d6cb438-9e70-4ada-a65e-a9302c49766a', 'Avenida José Gabriel Condorcanqui', -8.052417, -79.0561792, 2, true),
  ('6d6cb438-9e70-4ada-a65e-a9302c49766a', 'Calle B', -8.05845, -79.0536598, 3, true),
  ('6d6cb438-9e70-4ada-a65e-a9302c49766a', 'Avenida José Gabriel Condorcanqui, Urbanización Santa Inés', -8.0916478, -79.0406377, 4, true),
  ('6d6cb438-9e70-4ada-a65e-a9302c49766a', 'Avenida Nicolás de Piérola, Urbanización Santa Inés', -8.0974206, -79.038029, 5, true),
  ('6d6cb438-9e70-4ada-a65e-a9302c49766a', 'Avenida Manuel Vera Enríquez, Urbanización Santa Inés', -8.1016018, -79.0351237, 6, true),
  ('6d6cb438-9e70-4ada-a65e-a9302c49766a', 'Avenida España', -8.1059207, -79.0294266, 7, true),
  ('6d6cb438-9e70-4ada-a65e-a9302c49766a', 'Avenida Miraflores', -8.1052344, -79.0262549, 8, true),
  ('6d6cb438-9e70-4ada-a65e-a9302c49766a', 'Jirón Rimac', -8.1038931, -79.0243689, 9, true),
  ('6d6cb438-9e70-4ada-a65e-a9302c49766a', 'Avenida Manuel Vera Enríquez', -8.1061761, -79.0288411, 10, true),
  ('6d6cb438-9e70-4ada-a65e-a9302c49766a', 'Avenida José Gabriel Condorcanqui, Residencial Los Jardines de San Isidro', -8.1010421, -79.0355734, 11, true),
  ('6d6cb438-9e70-4ada-a65e-a9302c49766a', 'Avenida 2', -8.0624989, -79.0522553, 12, true);
