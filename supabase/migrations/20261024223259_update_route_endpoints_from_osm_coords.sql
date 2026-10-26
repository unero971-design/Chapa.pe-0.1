/*
# Actualizar start_point/end_point de rutas con coordenadas OSM (lote 6)

1. Cambios
- Actualiza start_point y end_point de 94 rutas que aún tienen placeholders (nombre → nombre)
- Usa las coordenadas del primer y último segmento de cada ruta (route_segments) 
- Mapea coordenadas a zonas/districtos conocidos de Trujillo usando CASE:
  * Salaverry (costa sur, lat > -8.06)
  * Huanchaco (costa norte, lat < -8.07, lng < -79.01)
  * Buenos Aires / Victor Larco (lat -8.09 a -8.11, lng -79.01 a -79.03)
  * Centro Histórico (lat -8.10 a -8.12, lng -79.02 a -79.04)
  * El Porvenir (lat -8.11 a -8.14, lng -79.02 a -79.05)
  * La Esperanza (lat -8.13 a -8.16, lng -79.03 a -79.06)
  * Florencia de Mora (lat -8.14 a -8.16, lng -79.03 a -79.05)
  * Alto Trujillo (lat < -8.14, lng -79.00 a -79.04)
  * Laredo (lng > -79.08)
  * Moche (lat > -8.17, lng < -79.00)
  * Gran Chimu (lat < -8.18, lng < -79.00)
  * Wichanzao (lat -8.11 a -8.14, lng -78.98 a -79.01)

2. Seguridad
- No cambia esquema ni políticas. Solo UPDATE de datos existentes.
- Las coordenadas vienen de route_segments ya cargados desde OSM.

3. Notas
- Esta es una aproximación basada en coordenadas, no en datos exactos de paraderos de Truxdi.
- Una futura mejora puede hacer reverse-geocoding con Nominatim para obtener nombres de calles exactos.
*/

UPDATE routes r SET
  start_point = sub.start_area,
  end_point = sub.end_area
FROM (
  SELECT
    r2.id,
    CASE
      WHEN f.lat > -8.06 THEN 'Salaverry'
      WHEN f.lat < -8.07 AND f.lng < -79.01 THEN 'Huanchaco'
      WHEN f.lat BETWEEN -8.09 AND -8.11 AND f.lng BETWEEN -79.03 AND -79.00 THEN 'Buenos Aires, Victor Larco'
      WHEN f.lat BETWEEN -8.10 AND -8.12 AND f.lng BETWEEN -79.03 AND -79.01 THEN 'Centro Histórico, Trujillo'
      WHEN f.lat BETWEEN -8.11 AND -8.14 AND f.lng BETWEEN -79.01 AND -79.05 THEN 'El Porvenir'
      WHEN f.lat BETWEEN -8.13 AND -8.16 AND f.lng BETWEEN -79.03 AND -79.06 THEN 'La Esperanza'
      WHEN f.lat BETWEEN -8.14 AND -8.17 AND f.lng BETWEEN -79.03 AND -79.05 THEN 'Florencia de Mora'
      WHEN f.lat < -8.14 AND f.lng BETWEEN -79.00 AND -79.05 THEN 'Alto Trujillo, El Porvenir'
      WHEN f.lng > -79.08 THEN 'Laredo'
      WHEN f.lat > -8.17 AND f.lng < -79.00 THEN 'Moche'
      WHEN f.lat < -8.18 AND f.lng < -79.00 THEN 'Gran Chimu, El Porvenir'
      WHEN f.lat BETWEEN -8.11 AND -8.14 AND f.lng BETWEEN -78.97 AND -79.01 THEN 'Wichanzao, Alto Trujillo'
      WHEN f.lat BETWEEN -8.10 AND -8.13 AND f.lng BETWEEN -79.04 AND -79.07 THEN 'San Andrés, El Porvenir'
      ELSE 'Trujillo'
    END as start_area,
    CASE
      WHEN l.lat > -8.06 THEN 'Salaverry'
      WHEN l.lat < -8.07 AND l.lng < -79.01 THEN 'Huanchaco'
      WHEN l.lat BETWEEN -8.09 AND -8.11 AND l.lng BETWEEN -79.03 AND -79.00 THEN 'Buenos Aires, Victor Larco'
      WHEN l.lat BETWEEN -8.10 AND -8.12 AND l.lng BETWEEN -79.03 AND -79.01 THEN 'Centro Histórico, Trujillo'
      WHEN l.lat BETWEEN -8.11 AND -8.14 AND l.lng BETWEEN -79.01 AND -79.05 THEN 'El Porvenir'
      WHEN l.lat BETWEEN -8.13 AND -8.16 AND l.lng BETWEEN -79.03 AND -79.06 THEN 'La Esperanza'
      WHEN l.lat BETWEEN -8.14 AND -8.17 AND l.lng BETWEEN -79.03 AND -79.05 THEN 'Florencia de Mora'
      WHEN l.lat < -8.14 AND l.lng BETWEEN -79.00 AND -79.05 THEN 'Alto Trujillo, El Porvenir'
      WHEN l.lng > -79.08 THEN 'Laredo'
      WHEN l.lat > -8.17 AND l.lng < -79.00 THEN 'Moche'
      WHEN l.lat < -8.18 AND l.lng < -79.00 THEN 'Gran Chimu, El Porvenir'
      WHEN l.lat BETWEEN -8.11 AND -8.14 AND l.lng BETWEEN -78.97 AND -79.01 THEN 'Wichanzao, Alto Trujillo'
      WHEN l.lat BETWEEN -8.10 AND -8.13 AND l.lng BETWEEN -79.04 AND -79.07 THEN 'San Andrés, El Porvenir'
      ELSE 'Trujillo'
    END as end_area
  FROM routes r2
  JOIN LATERAL (
    SELECT rs.lat, rs.lng FROM route_segments rs WHERE rs.route_id = r2.id ORDER BY rs.order ASC LIMIT 1
  ) f ON true
  JOIN LATERAL (
    SELECT rs.lat, rs.lng FROM route_segments rs WHERE rs.route_id = r2.id ORDER BY rs.order DESC LIMIT 1
  ) l ON true
  WHERE r2.start_point = r2.end_point AND r2.direction != 'Circular'
) sub
WHERE r.id = sub.id;