/*
# Update Route CT-01 A de Expreso Buenos Aires (r008) with real Truxdi stops

## Summary
Replaces the 6 approximate stops for route "CT-01 A de Expreso Buenos Aires"
(r008) with 12 real highlighted stops from the official Truxdi.com route card.

## Data Source
- Truxdi: https://truxdi.com/trujillo/rutas/ct-01-a-expreso-buenos-aires-circular
- 23 total paradas, 12 destacadas (highlighted)
- Route is circular (Sentido Circular): Jr. Sinchi Roca → Jr. Sinchi Roca
- Operated by Expreso Buenos Aires S.A.C.
- Pasaje: S/. 2.00, Duration: 35 min
- Connects Jirón Desamparados, Buenos Aires and Av. Victor Larco Herrera, Buenos Aires

## Stops (12 destacadas from Truxdi, snapped to OSM geometry)
01 Jirón Desamparados, Buenos Aires (order 1)
02 Calle Arequipa, Buenos Aires (order ~5)
04 Avenida Victor Larco Herrera, Víctor Larco Herrera (order ~11)
05 Pasaje Santa Beatriz (order ~14)
06 Óvalo Larco (order ~17)
07 Avenida Victor Larco Herrera, Urb. El Recreo 2ª Etapa (order ~31)
10 Avenida España, Urb. El Recreo 1ª Etapa (order ~81)
14 Calle Brasil, Urb. Torres Araujo (order ~95)
15 Calle Cuba, Urb. El Recreo 2ª Etapa (order ~121)
17 Avenida Victor Larco Herrera (order ~152)
21 Calle las Casuarinas, Víctor Larco Herrera (order ~187)
22 Avenida Victor Larco Herrera, Vista Alegre (order ~188)

## Security
- No RLS policy changes
- No new tables or columns
*/

-- Update route endpoints
UPDATE routes
SET start_point = 'Jirón Desamparados, Buenos Aires',
    end_point = 'Avenida Victor Larco Herrera, Vista Alegre'
WHERE id = '7370b839-6f08-4c23-8b82-8307883a550d';

-- Delete old approximate stops
DELETE FROM stops WHERE route_id = '7370b839-6f08-4c23-8b82-8307883a550d';

-- Insert 12 real Truxdi highlighted stops snapped to OSM geometry
INSERT INTO stops (route_id, name, lat, lng, "order", is_major)
VALUES
  ('7370b839-6f08-4c23-8b82-8307883a550d', 'Jirón Desamparados, Buenos Aires', -8.1389545, -79.0601817, 1, true),
  ('7370b839-6f08-4c23-8b82-8307883a550d', 'Calle Arequipa, Buenos Aires', -8.1402068, -79.0584937, 2, true),
  ('7370b839-6f08-4c23-8b82-8307883a550d', 'Avenida Victor Larco Herrera, Víctor Larco Herrera', -8.142325, -79.0565218, 3, true),
  ('7370b839-6f08-4c23-8b82-8307883a550d', 'Pasaje Santa Beatriz', -8.1434489, -79.0551889, 4, true),
  ('7370b839-6f08-4c23-8b82-8307883a550d', 'Óvalo Larco', -8.1424778, -79.054148, 5, true),
  ('7370b839-6f08-4c23-8b82-8307883a550d', 'Avenida Victor Larco Herrera, Urb. El Recreo 2ª Etapa', -8.128056, -79.0417641, 6, true),
  ('7370b839-6f08-4c23-8b82-8307883a550d', 'Avenida España, Urb. El Recreo 1ª Etapa', -8.1164691, -79.02816, 7, true),
  ('7370b839-6f08-4c23-8b82-8307883a550d', 'Calle Brasil, Urb. Torres Araujo', -8.1148086, -79.0247101, 8, true),
  ('7370b839-6f08-4c23-8b82-8307883a550d', 'Calle Cuba, Urb. El Recreo 2ª Etapa', -8.1186379, -79.0293847, 9, true),
  ('7370b839-6f08-4c23-8b82-8307883a550d', 'Avenida Victor Larco Herrera', -8.1247503, -79.0391092, 10, true),
  ('7370b839-6f08-4c23-8b82-8307883a550d', 'Calle las Casuarinas, Víctor Larco Herrera', -8.1429777, -79.0547783, 11, true),
  ('7370b839-6f08-4c23-8b82-8307883a550d', 'Avenida Victor Larco Herrera, Vista Alegre', -8.1434489, -79.0551889, 12, true);
