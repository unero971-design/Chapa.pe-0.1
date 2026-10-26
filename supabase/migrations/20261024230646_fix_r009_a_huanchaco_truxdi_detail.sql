-- r009: A de Huanchaco — corrección según ficha Truxdi
-- Truxdi: A / M-04 A, Circular, S/. 2.50, Cerro La Virgen → Cerro La Virgen
-- URL: https://truxdi.com/trujillo/rutas/a-huanchaco-circular
-- Las paradas ya coinciden con la ficha (12 destacadas, 43 totales)
UPDATE routes SET 
  fare_soles = 2.50,
  direction = 'Circular'
WHERE slug = 'r009';