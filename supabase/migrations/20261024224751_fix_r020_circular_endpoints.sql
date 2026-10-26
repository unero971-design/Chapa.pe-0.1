/*
# Corregir r020 (CT-09 A) endpoints por ser Circular
# r022 (CT-03 A) route_type: Truxdi la muestra como "Micro" en su página de detalle
*/

-- r020: Circular, start = end (coordenadas coinciden en -8.1116, -79.0231 → zona El Porvenir/Gran Chimu)
UPDATE routes SET 
  start_point = 'Avenida América Norte, El Porvenir',
  end_point = 'Avenida América Norte, El Porvenir'
WHERE slug = 'r020';

-- r022: CT-03 A Victor Larco - Truxdi página dice "Micro de transporte público"
-- Pero el catálogo la muestra como "CT-03 A" sin sufijo de tipo. Las CT- en Truxdi son "Unidad".
-- Mantenemos Unidad ya que el catálogo la clasifica así.