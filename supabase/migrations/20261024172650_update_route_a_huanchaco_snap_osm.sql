/*
# Update Route A de Huanchaco (r009) — snap stops to OSM geometry

## Summary
The 12 highlighted stops for "A de Huanchaco" (r009) already match the Truxdi
ficha names and order. This migration improves coordinate precision by snapping
each stop to its nearest point on the OSM geometry, and updates the route code
to match Truxdi's "A / M-04 A" designation.

## Data Source
- Truxdi: https://truxdi.com/trujillo/rutas/a-huanchaco-circular
- 43 total paradas, 12 destacadas
- Circular: Cerro La Virgen → Cerro La Virgen
- Operated by HUANCHACO S.A.
- Pasaje: S/. 2.50, Duration: 35 min

## Security
- No RLS policy changes
- No new tables or columns
*/

-- Update route code to match Truxdi
UPDATE routes
SET code = 'A / M-04 A',
    start_point = 'LI-724, Océano Verde',
    end_point = 'Avenida la Marina, Asentamiento Humano San Luis'
WHERE id = 'ba98a0d4-10a0-43af-934a-bebf4df8bb48';

-- Delete old stops
DELETE FROM stops WHERE route_id = 'ba98a0d4-10a0-43af-934a-bebf4df8bb48';

-- Re-insert 12 stops with coordinates snapped to OSM geometry
INSERT INTO stops (route_id, name, lat, lng, "order", is_major)
VALUES
  ('ba98a0d4-10a0-43af-934a-bebf4df8bb48', 'LI-724, Océano Verde', -8.1302506, -79.0209805, 1, true),
  ('ba98a0d4-10a0-43af-934a-bebf4df8bb48', 'Avenida Cerrito de la Virgen, Huanchaco Brisas', -8.1283869, -79.0216643, 2, true),
  ('ba98a0d4-10a0-43af-934a-bebf4df8bb48', 'Avenida Deán Saavedra', -8.1234153, -79.0226016, 3, true),
  ('ba98a0d4-10a0-43af-934a-bebf4df8bb48', 'Avenida Víctor Larco Herrera, Huanchaco Brisas', -8.1164691, -79.02816, 4, true),
  ('ba98a0d4-10a0-43af-934a-bebf4df8bb48', 'Avenida Aviación', -8.1116264, -79.0337084, 5, true),
  ('ba98a0d4-10a0-43af-934a-bebf4df8bb48', 'Carretera Panamericana Norte, San Francisco', -8.108726, -79.041116, 6, true),
  ('ba98a0d4-10a0-43af-934a-bebf4df8bb48', 'Avenida Ramón Castilla', -8.1051851, -79.0484212, 7, true),
  ('ba98a0d4-10a0-43af-934a-bebf4df8bb48', 'Avenida Mansiche', -8.0999443, -79.0634002, 8, true),
  ('ba98a0d4-10a0-43af-934a-bebf4df8bb48', 'Avenida Jesús de Nazareth', -8.0941049, -79.0727527, 9, true),
  ('ba98a0d4-10a0-43af-934a-bebf4df8bb48', 'Avenida España, Urbanización El Recreo 1ª Etapa', -8.0886434, -79.0967653, 10, true),
  ('ba98a0d4-10a0-43af-934a-bebf4df8bb48', 'Avenida 28 de Julio, Urbanización Torres Araujo', -8.0826213, -79.1197488, 11, true),
  ('ba98a0d4-10a0-43af-934a-bebf4df8bb48', 'Avenida la Marina, Asentamiento Humano San Luis', -8.0660298, -79.1099423, 12, true);
