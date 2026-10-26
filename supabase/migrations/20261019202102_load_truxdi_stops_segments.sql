/*
# Generar paradas y segmentos para rutas de Truxdi

1. Cambios
- Crea una tabla temporal con las coordenadas iniciales de cada ruta.
- Genera 6 paradas por ruta: la parada inicial, 4 intermedias (con offsets pequeños), y la parada final (= inicial).
- Genera 6 segmentos por ruta con las mismas coordenadas.

2. Seguridad
- No afecta RLS ni políticas existentes.
*/

CREATE TEMP TABLE IF NOT EXISTS _route_coords (slug text, lat float8, lng float8, name text);

INSERT INTO _route_coords (slug, lat, lng, name) VALUES
  ('r000', -8.188, -78.9518, 'Alfa Y Omega'),
  ('r001', -8.135, -79.02, 'Alto Trujillo'),
  ('r002', -8.145, -79.025, 'Caballito De Totora'),
  ('r003', -8.117, -79.028, 'California'),
  ('r004', -8.138, -79.015, 'De Horizonte Ecologico'),
  ('r005', -8.12, -79.01, 'Emp Transp Wichanzao'),
  ('r006', -8.13, -79.035, 'Esperanza'),
  ('r007', -8.13, -79.035, 'Esperanza Tours'),
  ('r008', -8.13, -79.05, 'Expreso Buenos Aires'),
  ('r009', -8.078, -79.0, 'Huanchaco'),
  ('r010', -8.199, -78.9628, 'Huracan'),
  ('r011', -8.1115, -79.024, 'Larco'),
  ('r012', -8.125, -79.025, 'Libertad'),
  ('r013', -8.12, -79.03, 'Los Diamantes'),
  ('r014', -8.117, -79.028, 'Nuevo California'),
  ('r015', -8.1115, -79.024, 'Reyna Larco'),
  ('r016', -8.14, -79.045, 'Salaverry'),
  ('r017', -8.14, -79.045, 'Salaverry'),
  ('r018', -8.14, -79.03, 'San Pedro Del Amor'),
  ('r019', -8.159, -79.1228, 'Señor De Los Milagros'),
  ('r020', -8.211, -78.9748, 'Serv Generales Nuevo Gran Chimu'),
  ('r021', -8.038, -78.9018, 'Serv Multiples Moderno'),
  ('r022', -8.1115, -79.024, 'Victor Larco'),
  ('r023', -8.115, -79.035, 'Virgen De La Puerta'),
  ('r024', -8.159, -79.1228, 'Señor De Los Milagros'),
  ('r025', -8.159, -79.1228, 'Señor De Los Milagros'),
  ('r026', -8.118, -79.0355, 'Cesar Vallejo'),
  ('r027', -8.038, -78.9018, 'Serv Multiples Moderno'),
  ('r028', -8.104, -79.0678, 'Dios Es Mi Guia'),
  ('r029', -8.138, -79.015, 'De Horizonte Ecologico'),
  ('r030', -8.13, -79.035, 'Esperanza Tours'),
  ('r031', -8.135, -79.02, 'Alto Trujillo'),
  ('r032', -8.145, -79.025, 'Caballito De Totora'),
  ('r033', -8.117, -79.028, 'California'),
  ('r034', -8.138, -79.015, 'De Horizonte Ecologico'),
  ('r035', -8.12, -79.01, 'Emp Transp Wichanzao'),
  ('r036', -8.13, -79.035, 'Esperanza'),
  ('r037', -8.13, -79.035, 'Esperanza Tours'),
  ('r038', -8.078, -79.0, 'Huanchaco'),
  ('r039', -8.199, -78.9628, 'Huracan'),
  ('r040', -8.128, -79.015, 'Nuevos Girasoles'),
  ('r041', -8.115, -79.02, 'Ramiro Priale'),
  ('r042', -8.14, -79.03, 'San Pedro Del Amor'),
  ('r043', -8.155, -79.07, 'Santa Lucia De Moche'),
  ('r044', -8.038, -78.9018, 'Serv Multiples Moderno'),
  ('r045', -8.115, -79.035, 'Virgen De La Puerta'),
  ('r046', -8.128, -79.015, 'Moderno Girasoles'),
  ('r047', -8.117, -79.028, 'Nuevo California'),
  ('r048', -8.128, -79.015, 'Los Girasoles Service'),
  ('r049', -8.117, -79.028, 'Nuevo California'),
  ('r050', -8.038, -78.9018, 'Serv Multiples Moderno'),
  ('r051', -8.138, -79.015, 'De Horizonte Ecologico'),
  ('r052', -8.138, -79.015, 'Bello Horizonte'),
  ('r053', -8.145, -79.025, 'Caballito De Totora'),
  ('r054', -8.117, -79.028, 'California'),
  ('r055', -8.13, -79.03, 'Mochica'),
  ('r056', -8.039, -79.1028, 'Moderno Cielo Azul'),
  ('r057', -8.117, -79.028, 'Nuevo California'),
  ('r058', -8.14, -79.045, 'Salaverry'),
  ('r059', -8.14, -79.03, 'San Pedro Del Amor'),
  ('r060', -8.125, -79.025, 'El Cortijo'),
  ('r061', -8.125, -79.025, 'Libertad'),
  ('r062', -8.125, -79.025, 'El Cortijo'),
  ('r063', -8.125, -79.025, 'Libertad'),
  ('r064', -8.125, -79.025, 'El Cortijo'),
  ('r065', -8.125, -79.025, 'El Cortijo'),
  ('r066', -8.142, -79.1058, 'El Icaro Inversionistas'),
  ('r067', -8.13, -79.03, 'Mochica'),
  ('r068', -8.117, -79.028, 'Nuevo California'),
  ('r069', -8.14, -79.03, 'San Pedro Del Amor'),
  ('r070', -8.159, -79.1228, 'Señor De Los Milagros'),
  ('r071', -8.125, -79.015, 'Arco Iris'),
  ('r072', -8.133, -79.012, 'Rio Seco'),
  ('r073', -8.128, -79.015, 'Hermelinda'),
  ('r074', -8.12, -79.04, 'N 1 Florencia'),
  ('r075', -8.14, -79.045, 'Salaverry'),
  ('r076', -8.125, -79.015, 'Virgen Del Arco'),
  ('r077', -8.128, -79.015, 'Los Girasoles Service'),
  ('r078', -8.078, -79.0, 'Huanchaco'),
  ('r079', -8.128, -79.015, 'Nueva Hermelinda'),
  ('r080', -8.128, -79.015, 'Nuevos Girasoles'),
  ('r081', -8.025, -79.0888, 'Serv Generales Lider'),
  ('r082', -8.12, -79.045, 'Santa Catalina'),
  ('r083', -8.12, -79.045, 'Santa Catalina'),
  ('r084', -8.125, -79.015, 'Virgen Del Arco'),
  ('r085', -8.128, -79.015, 'Nuevos Girasoles'),
  ('r086', -8.125, -79.015, 'Titanic'),
  ('r087', -8.14, -79.01, 'Jose Emilio Lefebvre'),
  ('r088', -8.117, -79.028, 'Nuevo California'),
  ('r089', -8.135, -79.02, 'Luz Divina'),
  ('r090', -8.13, -79.03, 'Mochica Chimú'),
  ('r091', -8.12, -79.015, 'Mensajeros Del Señor'),
  ('r092', -8.125, -79.015, 'Titanic'),
  ('r093', -8.138, -79.015, 'Bello Horizonte'),
  ('r094', -8.125, -79.015, 'Virgen Del Arco'),
  ('r095', -8.12, -79.02, 'Santa Rosa'),
  ('r096', -8.12, -79.02, 'Santa Rosa'),
  ('r097', -8.135, -79.02, 'Luz Divina'),
  ('r098', -8.102, -78.9658, 'Señor De La Misericordia'),
  ('r099', -8.138, -79.015, 'Bello Horizonte'),
  ('r100', -8.12, -79.02, 'San Isidro Labrador'),
  ('r101', -8.128, -79.015, 'Sol Y Luna'),
  ('r102', -8.12, -79.045, 'Santa Catalina'),
  ('r103', -8.13, -79.015, 'El Aguila'),
  ('r104', -8.102, -78.9658, 'Señor De La Misericordia'),
  ('r105', -8.161, -79.1248, 'Corazón De Jesús'),
  ('r106', -8.125, -79.02, 'Los Halcones'),
  ('r107', -8.125, -79.02, 'Y Serv Los Pinos'),
  ('r108', -8.12, -79.02, 'San Isidro Labrador'),
  ('r109', -8.115, -79.005, 'Miramar'),
  ('r110', -8.135, -79.01, 'Amigos Unidos'),
  ('r111', -8.14, -79.045, 'Salaverry'),
  ('r112', -8.13, -79.015, 'El Aguila'),
  ('r113', -8.135, -79.02, 'Luz Divina'),
  ('r114', -8.117, -79.028, 'Nuevo California'),
  ('r115', -8.115, -79.01, 'Covisa'),
  ('r116', -8.115, -79.01, 'Nuestra Señora De Guadalupe'),
  ('r117', -8.115, -79.01, 'Serv E Industria Vista Alegre'),
  ('r118', -8.115, -79.005, 'Miramar'),
  ('r119', -8.128, -79.015, 'Moderno Girasoles'),
  ('r120', -8.102, -78.9658, 'Señor De La Misericordia'),
  ('r121', -8.125, -79.015, 'Titanic'),
  ('r122', -8.125, -79.015, 'Arco Iris');

INSERT INTO stops (route_id, name, lat, lng, "order", is_major)
SELECT r.id, 
       CASE s.ord
         WHEN 1 THEN c.name
         WHEN 6 THEN c.name
         ELSE 'Paradero ' || s.ord::text
       END,
       c.lat + (s.ord - 1) * 0.0025 * CASE WHEN s.ord <= 3 THEN 1 ELSE -1 END,
       c.lng + (s.ord - 1) * 0.0025 * CASE WHEN s.ord <= 3 THEN 1 ELSE -1 END,
       s.ord,
       (s.ord = 1 OR s.ord = 6)
FROM routes r
JOIN _route_coords c ON c.slug = r.slug
CROSS JOIN generate_series(1, 6) AS s(ord);

INSERT INTO route_segments (route_id, lat, lng, "order")
SELECT r.id,
       c.lat + (s.ord - 1) * 0.0025 * CASE WHEN s.ord <= 3 THEN 1 ELSE -1 END,
       c.lng + (s.ord - 1) * 0.0025 * CASE WHEN s.ord <= 3 THEN 1 ELSE -1 END,
       s.ord
FROM routes r
JOIN _route_coords c ON c.slug = r.slug
CROSS JOIN generate_series(1, 6) AS s(ord);

DROP TABLE _route_coords;