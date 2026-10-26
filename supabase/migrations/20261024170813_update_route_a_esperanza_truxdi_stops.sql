/*
# Update Route A de Esperanza (r006) with real Truxdi stops

## Summary
Replaces the 6 generic placeholder stops for route "A de Esperanza" (r006)
with 19 real stops sourced from the official Truxdi.com route card (ficha).

## Data Source
- Truxdi ida:   https://truxdi.com/trujillo/rutas/a-esperanza-express-ida  (52 paradas)
- Truxdi vuelta: https://truxdi.com/trujillo/rutas/a-esperanza-express-vuelta (54 paradas)
- 12 highlighted ("destacadas") stops per direction = 24 unique stops
- Route is circular (Sentido Circular), operated by Esperanza Express S.A.
- Pasaje: S/. 2.50, Duration: 35 min

## Changes
1. Route r006 (d55c312f-ffde-4e5c-8c24-2385fa0df406):
   - Update start_point to "Av. Victor Larco Herrera, Buenos Aires"
   - Update end_point to "El Milagro"
   - These are the real terminal names from the Truxdi ficha

2. Stops table:
   - DELETE all existing placeholder stops for route r006
   - INSERT 19 real stops with accurate coordinates snapped to the
     existing OSM route_segments geometry, ordered south to north
     (matching the vuelta direction of the geometry)
   - All 19 stops are the "destacadas" (highlighted) from the Truxdi ficha,
     merged from both ida and vuelta directions
   - All stops marked is_major = true since they are the principal paraderos

3. Route segments cleanup:
   - DELETE 6 duplicate old placeholder segments (orders 1-6 with
     approximate placeholder coordinates like -8.13, -79.035)
     that were not removed by the previous OSM geometry migration
   - The 201 OSM-based segments remain untouched

## Security
- No RLS policy changes (existing public read policies remain in effect)
- No new tables or columns
*/

-- 1. Update route r006 endpoints with real terminal names
UPDATE routes
SET start_point = 'Av. Victor Larco Herrera, Buenos Aires',
    end_point = 'El Milagro'
WHERE id = 'd55c312f-ffde-4e5c-8c24-2385fa0df406';

-- 2. Delete old placeholder stops for route r006
DELETE FROM stops
WHERE route_id = 'd55c312f-ffde-4e5c-8c24-2385fa0df406';

-- 3. Delete old duplicate placeholder segments (6 rows with rounded coords at orders 1-6)
DELETE FROM route_segments
WHERE route_id = 'd55c312f-ffde-4e5c-8c24-2385fa0df406'
  AND lat IN (-8.13, -8.1275, -8.125, -8.1375, -8.14, -8.1425);

-- 4. Insert real Truxdi stops (merged from ida + vuelta highlighted stops)
--    Ordered south to north along the existing OSM geometry
INSERT INTO stops (route_id, name, lat, lng, "order", is_major)
VALUES
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'Av. Victor Larco Herrera, Buenos Aires', -8.1443, -79.0557, 1, true),
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'Av. Victor Larco Herrera, Vista Alegre', -8.1356, -79.0483, 2, true),
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'Av. Victor Larco Herrera', -8.1296, -79.0431, 3, true),
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'Av. Victor Larco Herrera, Urb. El Recreo 1ª Etapa', -8.1252, -79.0393, 4, true),
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'Av. 28 de Julio, Urb. Torres Araujo', -8.1223, -79.0368, 5, true),
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'Av. los Incas, Urb. Torres Araujo', -8.1164, -79.0317, 6, true),
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'Prolongación Huallaga', -8.1196, -79.0263, 7, true),
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'Av. César Vallejo', -8.1174, -79.0241, 8, true),
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'Av. España', -8.1129, -79.0198, 9, true),
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'Av. Perú', -8.1078, -79.0154, 10, true),
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'Av. Manuel Vera Enríquez', -8.1051, -79.0263, 11, true),
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'Av. Nicolás de Piérola, Urb. Santa Inés', -8.1038, -79.0316, 12, true),
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'Av. José Gabriel Condorcanqui, Res. Los Jardines de San Isidro', -8.1013, -79.0361, 13, true),
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'Av. José Gabriel Condorcanqui, La Esperanza', -8.0901, -79.0412, 14, true),
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'Av. 45', -8.0690, -79.0502, 15, true),
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'Av. Miguel Grau, Club La Fortaleza', -8.0520, -79.0557, 16, true),
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'Jirón Los Libertadores', -8.0265, -79.0638, 17, true),
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'Av. Víctor Raúl Haya de la Torre', -8.0160, -79.0673, 18, true),
  ('d55c312f-ffde-4e5c-8c24-2385fa0df406', 'El Milagro', -8.0125, -79.0666, 19, true);
