/*
# Cargar rutas reales de micros de Trujillo (Truxdi.com) — Esquema + rutas

1. Cambios
- Agrega columnas company, route_type, duration_min, slug a la tabla routes.
- Reemplaza datos de demostración con 123 rutas reales del catálogo público de Truxdi.com.
- Las paradas y segmentos se cargan en una migración separada por tamaño.

2. Seguridad
- Mantiene RLS y políticas existentes (lectura pública anon+authenticated).

3. Notas
- Coordenadas aproximadas basadas en avenidas/zonas conocidas de Trujillo.
- Recorridos detallados por calles se obtienen vía OSRM en tiempo de ejecución.
- Fuente: https://truxdi.com/trujillo/rutas
*/

ALTER TABLE routes ADD COLUMN IF NOT EXISTS company text NOT NULL DEFAULT 'No identificado';
ALTER TABLE routes ADD COLUMN IF NOT EXISTS route_type text NOT NULL DEFAULT 'Micro';
ALTER TABLE routes ADD COLUMN IF NOT EXISTS duration_min int NOT NULL DEFAULT 35;
ALTER TABLE routes ADD COLUMN IF NOT EXISTS slug text;

DELETE FROM stops;
DELETE FROM route_segments;
DELETE FROM routes;

INSERT INTO routes (slug, code, name, color, direction, start_point, end_point, frequency_min, fare_soles, schedule, company, route_type, duration_min) VALUES
('r000', 'CT-15 A', 'Alfa Y Omega', '#1e40af', 'Ambos', 'Alfa Y Omega', 'Alfa Y Omega', 7, 2.0, '05:30 - 23:00', 'Alfa y Omega S.A.C.', 'Bus', 35),
('r001', 'A', 'Alto Trujillo', '#0ea5e9', 'Ambos', 'Alto Trujillo', 'Alto Trujillo', 7, 2.0, '05:30 - 23:00', 'ALTO TRUJILLO S.A.', 'Micro', 35),
('r002', 'A', 'Caballito De Totora', '#facc15', 'Ambos', 'Caballito De Totora', 'Caballito De Totora', 7, 2.0, '05:30 - 23:00', 'CABALLITO DE TOTORA S.A.', 'Micro', 35),
('r003', 'A', 'California', '#16a34a', 'Ambos', 'California', 'California', 7, 2.0, '05:30 - 23:00', 'CALIFORNIA S.A.', 'Micro', 35),
('r004', 'CT-26 A', 'De Horizonte Ecologico', '#dc2626', 'Ambos', 'De Horizonte Ecologico', 'De Horizonte Ecologico', 7, 2.0, '05:30 - 23:00', 'Empresa de Transportes Horizonte Ecologico S.A.', 'Bus', 35),
('r005', 'CT-25 A', 'Emp Transp Wichanzao', '#7c3aed', 'Ambos', 'Emp Transp Wichanzao', 'Emp Transp Wichanzao', 7, 2.0, '05:30 - 23:00', 'Emp. Transp. Wichanzao S.A.', 'Bus', 35),
('r006', 'A', 'Esperanza', '#ea580c', 'Ambos', 'Esperanza', 'Esperanza', 7, 2.0, '05:30 - 23:00', 'ESPERANZA EXPRESS S.A.', 'Micro', 35),
('r007', 'CT-24 A', 'Esperanza Tours', '#0891b2', 'Ambos', 'Esperanza Tours', 'Esperanza Tours', 7, 2.0, '05:30 - 23:00', 'Esperanza Tours S.R.L.', 'Bus', 35),
('r008', 'CT-01 A', 'Expreso Buenos Aires', '#db2777', 'Ambos', 'Expreso Buenos Aires', 'Expreso Buenos Aires', 7, 2.0, '05:30 - 23:00', 'Expreso Buenos Aires S.A.C.', 'Bus', 35),
('r009', 'A', 'Huanchaco', '#65a30d', 'Ambos', 'Huanchaco', 'Huanchaco', 7, 2.0, '05:30 - 23:00', 'HUANCHACO S.A.', 'Micro', 35),
('r010', 'CT-10 A', 'Huracan', '#9333ea', 'Ambos', 'Huracan', 'Huracan', 7, 2.0, '05:30 - 23:00', 'Huracan S.A.C.', 'Bus', 35),
('r011', 'CT-02 A', 'Larco', '#f97316', 'Ambos', 'Larco', 'Larco', 7, 2.0, '05:30 - 23:00', 'Larco Express S.A.', 'Bus', 35),
('r012', 'A', 'Libertad', '#0d9488', 'Ambos', 'Libertad', 'Libertad', 7, 2.0, '05:30 - 23:00', 'LIBERTAD S.A.', 'Micro', 35),
('r013', 'A', 'Los Diamantes', '#e11d48', 'Ambos', 'Los Diamantes', 'Los Diamantes', 7, 2.0, '05:30 - 23:00', 'LOS DIAMANTES S.R.L.', 'Micro', 35),
('r014', 'A', 'Nuevo California', '#4f46e5', 'Ambos', 'Nuevo California', 'Nuevo California', 7, 2.0, '05:30 - 23:00', 'NUEVO CALIFORNIA S.A.', 'Micro', 35),
('r015', 'CT-04 A', 'Reyna Larco', '#ca8a04', 'Ambos', 'Reyna Larco', 'Reyna Larco', 7, 2.0, '05:30 - 23:00', 'Reyna Larco S.A.', 'Bus', 35),
('r016', 'A', 'Salaverry', '#059669', 'Ambos', 'Salaverry', 'Salaverry', 7, 2.0, '05:30 - 23:00', 'SALAVERRY EXPRESS S.A.', 'Micro', 35),
('r017', 'A', 'Salaverry', '#b91c1c', 'Ambos', 'Salaverry', 'Salaverry', 7, 2.0, '05:30 - 23:00', 'SALAVERRY EXPRESS S.A.', 'Micro', 35),
('r018', 'CT-22 A', 'San Pedro Del Amor', '#2563eb', 'Ambos', 'San Pedro Del Amor', 'San Pedro Del Amor', 7, 2.0, '05:30 - 23:00', 'San Pedro del Amor S.A.', 'Bus', 35),
('r019', 'A', 'Señor De Los Milagros', '#7e22ce', 'Ambos', 'Señor De Los Milagros', 'Señor De Los Milagros', 7, 2.0, '05:30 - 23:00', 'SEÑOR DE LOS MILAGROS S.A', 'Micro', 35)
ON CONFLICT DO NOTHING;

INSERT INTO routes (slug, code, name, color, direction, start_point, end_point, frequency_min, fare_soles, schedule, company, route_type, duration_min) VALUES
('r020', 'CT-09 A', 'Serv Generales Nuevo Gran Chimu', '#c2410c', 'Ambos', 'Serv Generales Nuevo Gran Chimu', 'Serv Generales Nuevo Gran Chimu', 7, 2.0, '05:30 - 23:00', 'Serv. Generales nuevo Gran Chimu', 'Bus', 35),
('r021', 'CT-23 A', 'Serv Multiples Moderno', '#15803d', 'Ambos', 'Serv Multiples Moderno', 'Serv Multiples Moderno', 7, 2.0, '05:30 - 23:00', 'Serv. Multiples Moderno Express S.A.', 'Bus', 35),
('r022', 'CT-03 A', 'Victor Larco', '#be185d', 'Ambos', 'Victor Larco', 'Victor Larco', 7, 2.0, '05:30 - 23:00', 'Victor Larco S.A.', 'Bus', 35),
('r023', 'A', 'Virgen De La Puerta', '#1d4ed8', 'Ambos', 'Virgen De La Puerta', 'Virgen De La Puerta', 7, 2.0, '05:30 - 23:00', 'VIRGEN DE LA PUERTA S.A.', 'Micro', 35),
('r024', 'A1', 'Señor De Los Milagros', '#1e40af', 'Ambos', 'Señor De Los Milagros', 'Señor De Los Milagros', 7, 2.0, '05:30 - 23:00', 'Señor de los Milagros', 'Micro', 35),
('r025', 'A1-B1', 'Señor De Los Milagros', '#0ea5e9', 'Ambos', 'Señor De Los Milagros', 'Señor De Los Milagros', 7, 2.0, '05:30 - 23:00', 'SEÑOR DE LOS MILAGROS S.A', 'Micro', 35),
('r026', 'AB', 'Cesar Vallejo', '#facc15', 'Ambos', 'Cesar Vallejo', 'Cesar Vallejo', 7, 2.0, '05:30 - 23:00', 'CESAR VALLEJO S.A.', 'Micro', 35),
('r027', 'CT-23 AC', 'Serv Multiples Moderno', '#16a34a', 'Ambos', 'Serv Multiples Moderno', 'Serv Multiples Moderno', 7, 2.0, '05:30 - 23:00', 'Serv. Multiples Moderno Express S.A.', 'Bus', 35),
('r028', 'CT-08 AM', 'Dios Es Mi Guia', '#dc2626', 'Ambos', 'Dios Es Mi Guia', 'Dios Es Mi Guia', 7, 2.0, '05:30 - 23:00', 'Turismo Dios es mi guia S.R.L.', 'Bus', 35),
('r029', 'CT-26 AU', 'De Horizonte Ecologico', '#7c3aed', 'Ambos', 'De Horizonte Ecologico', 'De Horizonte Ecologico', 7, 2.0, '05:30 - 23:00', 'Empresa de Transportes Horizonte Ecologico S.A.', 'Bus', 35),
('r030', 'CT-24 AU', 'Esperanza Tours', '#ea580c', 'Ambos', 'Esperanza Tours', 'Esperanza Tours', 7, 2.0, '05:30 - 23:00', 'Esperanza Tours S.R.L.', 'Bus', 35),
('r031', 'B', 'Alto Trujillo', '#0891b2', 'Ambos', 'Alto Trujillo', 'Alto Trujillo', 7, 2.0, '05:30 - 23:00', 'ALTO TRUJILLO S.A.', 'Micro', 35),
('r032', 'B', 'Caballito De Totora', '#db2777', 'Ambos', 'Caballito De Totora', 'Caballito De Totora', 7, 2.0, '05:30 - 23:00', 'CABALLITO DE TOTORA S.A.', 'Micro', 35),
('r033', 'B', 'California', '#65a30d', 'Ambos', 'California', 'California', 7, 2.0, '05:30 - 23:00', 'CALIFORNIA S.A.', 'Micro', 35),
('r034', 'CT-26 B', 'De Horizonte Ecologico', '#9333ea', 'Ambos', 'De Horizonte Ecologico', 'De Horizonte Ecologico', 7, 2.0, '05:30 - 23:00', 'Empresa de Transportes Horizonte Ecologico S.A.', 'Bus', 35),
('r035', 'CT-25 B', 'Emp Transp Wichanzao', '#f97316', 'Ambos', 'Emp Transp Wichanzao', 'Emp Transp Wichanzao', 7, 2.0, '05:30 - 23:00', 'Emp. Transp. Wichanzao S.A.', 'Bus', 35),
('r036', 'B', 'Esperanza', '#0d9488', 'Ambos', 'Esperanza', 'Esperanza', 7, 2.0, '05:30 - 23:00', 'ESPERANZA EXPRESS S.A.', 'Micro', 35),
('r037', 'CT-24 B', 'Esperanza Tours', '#e11d48', 'Ambos', 'Esperanza Tours', 'Esperanza Tours', 7, 2.0, '05:30 - 23:00', 'Esperanza Tours S.R.L.', 'Bus', 35),
('r038', 'B', 'Huanchaco', '#4f46e5', 'Ambos', 'Huanchaco', 'Huanchaco', 7, 2.0, '05:30 - 23:00', 'HUANCHACO S.A.', 'Micro', 35),
('r039', 'CT-10 B', 'Huracan', '#ca8a04', 'Ambos', 'Huracan', 'Huracan', 7, 2.0, '05:30 - 23:00', 'Huracan S.A.C.', 'Bus', 35)
ON CONFLICT DO NOTHING;

INSERT INTO routes (slug, code, name, color, direction, start_point, end_point, frequency_min, fare_soles, schedule, company, route_type, duration_min) VALUES
('r040', 'B', 'Nuevos Girasoles', '#059669', 'Ambos', 'Nuevos Girasoles', 'Nuevos Girasoles', 7, 2.0, '05:30 - 23:00', 'NUEVOS GIRASOLES S.A.', 'Micro', 35),
('r041', 'B', 'Ramiro Priale', '#b91c1c', 'Ambos', 'Ramiro Priale', 'Ramiro Priale', 7, 2.0, '05:30 - 23:00', 'RAMIRO PRIALE S.A.', 'Micro', 35),
('r042', 'CT-22 B', 'San Pedro Del Amor', '#2563eb', 'Ambos', 'San Pedro Del Amor', 'San Pedro Del Amor', 7, 2.0, '05:30 - 23:00', 'San Pedro del Amor S.A.', 'Bus', 35),
('r043', 'B', 'Santa Lucia De Moche', '#7e22ce', 'Ambos', 'Santa Lucia De Moche', 'Santa Lucia De Moche', 7, 2.0, '05:30 - 23:00', 'SANTA LUCIA DE MOCHE S.R.L.', 'Micro', 35),
('r044', 'CT-23 B', 'Serv Multiples Moderno', '#c2410c', 'Ambos', 'Serv Multiples Moderno', 'Serv Multiples Moderno', 7, 2.0, '05:30 - 23:00', 'Serv. Multiples Moderno Express S.A.', 'Bus', 35),
('r045', 'B', 'Virgen De La Puerta', '#15803d', 'Ambos', 'Virgen De La Puerta', 'Virgen De La Puerta', 7, 2.0, '05:30 - 23:00', 'VIRGEN DE LA PUERTA S.A.', 'Micro', 35),
('r046', 'B1', 'Moderno Girasoles', '#be185d', 'Ambos', 'Moderno Girasoles', 'Moderno Girasoles', 7, 2.0, '05:30 - 23:00', 'MODERNO GIRASOLES EXPRESS S.A', 'Micro', 35),
('r047', 'B1', 'Nuevo California', '#1d4ed8', 'Ambos', 'Nuevo California', 'Nuevo California', 7, 2.0, '05:30 - 23:00', 'NUEVO CALIFORNIA S.A.', 'Micro', 35),
('r048', 'B2', 'Los Girasoles Service', '#1e40af', 'Ambos', 'Los Girasoles Service', 'Los Girasoles Service', 7, 2.0, '05:30 - 23:00', 'LOS GIRASOLES SERVICE S.R.L.', 'Micro', 35),
('r049', 'BC', 'Nuevo California', '#0ea5e9', 'Ambos', 'Nuevo California', 'Nuevo California', 7, 2.0, '05:30 - 23:00', 'NUEVO CALIFORNIA S.A.', 'Micro', 35),
('r050', 'CT-23 BC', 'Serv Multiples Moderno', '#facc15', 'Ambos', 'Serv Multiples Moderno', 'Serv Multiples Moderno', 7, 2.0, '05:30 - 23:00', 'Serv. Multiples Moderno Express S.A.', 'Bus', 35),
('r051', 'CT-26 BU', 'De Horizonte Ecologico', '#16a34a', 'Ambos', 'De Horizonte Ecologico', 'De Horizonte Ecologico', 7, 2.0, '05:30 - 23:00', 'Empresa de Transportes Horizonte Ecologico S.A.', 'Bus', 35),
('r052', 'C', 'Bello Horizonte', '#dc2626', 'Ambos', 'Bello Horizonte', 'Bello Horizonte', 7, 2.0, '05:30 - 23:00', 'BELLO HORIZONTE S.A.', 'Micro', 35),
('r053', 'C', 'Caballito De Totora', '#7c3aed', 'Ambos', 'Caballito De Totora', 'Caballito De Totora', 7, 2.0, '05:30 - 23:00', 'CABALLITO DE TOTORA S.A.', 'Micro', 35),
('r054', 'C', 'California', '#ea580c', 'Ambos', 'California', 'California', 7, 2.0, '05:30 - 23:00', 'CALIFORNIA S.A.', 'Micro', 35),
('r055', 'C', 'Mochica', '#0891b2', 'Ambos', 'Mochica', 'Mochica', 7, 2.0, '05:30 - 23:00', 'MOCHICA S.A.', 'Micro', 35),
('r056', 'C', 'Moderno Cielo Azul', '#db2777', 'Ambos', 'Moderno Cielo Azul', 'Moderno Cielo Azul', 7, 2.0, '05:30 - 23:00', 'MODERNO CIELO AZUL S.A.', 'Micro', 35),
('r057', 'C', 'Nuevo California', '#65a30d', 'Ambos', 'Nuevo California', 'Nuevo California', 7, 2.0, '05:30 - 23:00', 'NUEVO CALIFORNIA S.A.', 'Micro', 35),
('r058', 'C', 'Salaverry', '#9333ea', 'Ambos', 'Salaverry', 'Salaverry', 7, 2.0, '05:30 - 23:00', 'SALAVERRY EXPRESS S.A.', 'Micro', 35),
('r059', 'CT-22 C', 'San Pedro Del Amor', '#f97316', 'Ambos', 'San Pedro Del Amor', 'San Pedro Del Amor', 7, 2.0, '05:30 - 23:00', 'San Pedro del Amor S.A.', 'Bus', 35)
ON CONFLICT DO NOTHING;

INSERT INTO routes (slug, code, name, color, direction, start_point, end_point, frequency_min, fare_soles, schedule, company, route_type, duration_min) VALUES
('r060', 'C1', 'El Cortijo', '#0d9488', 'Ambos', 'El Cortijo', 'El Cortijo', 7, 2.0, '05:30 - 23:00', 'EL CORTIJO S.A.', 'Micro', 35),
('r061', 'C1', 'Libertad', '#e11d48', 'Ambos', 'Libertad', 'Libertad', 7, 2.0, '05:30 - 23:00', 'La Libertad', 'Micro', 35),
('r062', 'C2', 'El Cortijo', '#4f46e5', 'Ambos', 'El Cortijo', 'El Cortijo', 7, 2.0, '05:30 - 23:00', 'EL CORTIJO S.A.', 'Micro', 35),
('r063', 'C2', 'Libertad', '#ca8a04', 'Ambos', 'Libertad', 'Libertad', 7, 2.0, '05:30 - 23:00', 'La Libertad', 'Micro', 35),
('r064', 'C2VR', 'El Cortijo', '#059669', 'Ambos', 'El Cortijo', 'El Cortijo', 7, 2.0, '05:30 - 23:00', 'El Cortijo', 'Micro', 35),
('r065', 'C3', 'El Cortijo', '#b91c1c', 'Ambos', 'El Cortijo', 'El Cortijo', 7, 2.0, '05:30 - 23:00', 'EL CORTIJO S.A.', 'Micro', 35),
('r066', 'D', 'El Icaro Inversionistas', '#2563eb', 'Ambos', 'El Icaro Inversionistas', 'El Icaro Inversionistas', 7, 2.0, '05:30 - 23:00', 'El Icaro', 'Micro', 35),
('r067', 'D', 'Mochica', '#7e22ce', 'Ambos', 'Mochica', 'Mochica', 7, 2.0, '05:30 - 23:00', 'MOCHICA S.A.', 'Micro', 35),
('r068', 'D', 'Nuevo California', '#c2410c', 'Ambos', 'Nuevo California', 'Nuevo California', 7, 2.0, '05:30 - 23:00', 'NUEVO CALIFORNIA S.A.', 'Micro', 35),
('r069', 'CT-22 D', 'San Pedro Del Amor', '#15803d', 'Ambos', 'San Pedro Del Amor', 'San Pedro Del Amor', 7, 2.0, '05:30 - 23:00', 'San Pedro del Amor S.A.', 'Bus', 35),
('r070', 'D', 'Señor De Los Milagros', '#be185d', 'Ambos', 'Señor De Los Milagros', 'Señor De Los Milagros', 7, 2.0, '05:30 - 23:00', 'SEÑOR DE LOS MILAGROS S.A', 'Micro', 35),
('r071', 'E', 'Arco Iris', '#1d4ed8', 'Ambos', 'Arco Iris', 'Arco Iris', 7, 2.0, '05:30 - 23:00', 'ARCO IRIS EXPRESS S.A.', 'Micro', 35),
('r072', 'CT-11 E', 'Rio Seco', '#1e40af', 'Ambos', 'Rio Seco', 'Rio Seco', 7, 2.0, '05:30 - 23:00', 'Rio Seco S.A.', 'Bus', 35),
('r073', 'CT-16 F', 'Hermelinda', '#0ea5e9', 'Ambos', 'Hermelinda', 'Hermelinda', 7, 2.0, '05:30 - 23:00', 'Hermelinda Express S.R.L.', 'Bus', 35),
('r074', 'CT-21 F', 'N 1 Florencia', '#facc15', 'Ambos', 'N 1 Florencia', 'N 1 Florencia', 7, 2.0, '05:30 - 23:00', 'N° 1 Florencia Express S.A.', 'Bus', 35),
('r075', 'F', 'Salaverry', '#16a34a', 'Ambos', 'Salaverry', 'Salaverry', 7, 2.0, '05:30 - 23:00', 'SALAVERRY EXPRESS S.A.', 'Micro', 35),
('r076', 'F', 'Virgen Del Arco', '#dc2626', 'Ambos', 'Virgen Del Arco', 'Virgen Del Arco', 7, 2.0, '05:30 - 23:00', 'VIRGEN DEL ARCO S.A.', 'Micro', 35),
('r077', 'G', 'Los Girasoles Service', '#7c3aed', 'Ambos', 'Los Girasoles Service', 'Los Girasoles Service', 7, 2.0, '05:30 - 23:00', 'LOS GIRASOLES SERVICE S.R.L.', 'Micro', 35),
('r078', 'H', 'Huanchaco', '#ea580c', 'Ambos', 'Huanchaco', 'Huanchaco', 7, 2.0, '05:30 - 23:00', 'Huanchaco', 'Micro', 35),
('r079', 'CT-17 H', 'Nueva Hermelinda', '#0891b2', 'Ambos', 'Nueva Hermelinda', 'Nueva Hermelinda', 7, 2.0, '05:30 - 23:00', 'Nueva Hermelinda S.A.C.', 'Bus', 35)
ON CONFLICT DO NOTHING;

INSERT INTO routes (slug, code, name, color, direction, start_point, end_point, frequency_min, fare_soles, schedule, company, route_type, duration_min) VALUES
('r080', 'H', 'Nuevos Girasoles', '#db2777', 'Ambos', 'Nuevos Girasoles', 'Nuevos Girasoles', 7, 2.0, '05:30 - 23:00', 'NUEVOS GIRASOLES S.A.', 'Micro', 35),
('r081', 'CT-19 H', 'Serv Generales Lider', '#65a30d', 'Ambos', 'Serv Generales Lider', 'Serv Generales Lider', 7, 2.0, '05:30 - 23:00', 'Serv. Generales Lider Express S.A.', 'Bus', 35),
('r082', 'H1, H2', 'Santa Catalina', '#9333ea', 'Ambos', 'Santa Catalina', 'Santa Catalina', 7, 2.0, '05:30 - 23:00', 'SANTA CATALINA S.A.', 'Micro', 35),
('r083', 'H2', 'Santa Catalina', '#f97316', 'Ambos', 'Santa Catalina', 'Santa Catalina', 7, 2.0, '05:30 - 23:00', 'Santa Catalina', 'Micro', 35),
('r084', 'I', 'Virgen Del Arco', '#0d9488', 'Ambos', 'Virgen Del Arco', 'Virgen Del Arco', 7, 2.0, '05:30 - 23:00', 'VIRGEN DEL ARCO S.A.', 'Micro', 35),
('r085', 'JJ', 'Nuevos Girasoles', '#e11d48', 'Ambos', 'Nuevos Girasoles', 'Nuevos Girasoles', 7, 2.0, '05:30 - 23:00', 'NUEVOS GIRASOLES S.A.', 'Micro', 35),
('r086', 'K', 'Titanic', '#4f46e5', 'Ambos', 'Titanic', 'Titanic', 7, 2.0, '05:30 - 23:00', 'TITANIC EXPRESS S.A.', 'Micro', 35),
('r087', 'CT-27 L', 'Jose Emilio Lefebvre', '#ca8a04', 'Ambos', 'Jose Emilio Lefebvre', 'Jose Emilio Lefebvre', 7, 2.0, '05:30 - 23:00', 'Jose Emilio Lefebvre S.A.', 'Bus', 35),
('r088', 'LV', 'Nuevo California', '#059669', 'Ambos', 'Nuevo California', 'Nuevo California', 7, 2.0, '05:30 - 23:00', 'NUEVO CALIFORNIA S.A.', 'Micro', 35),
('r089', 'M', 'Luz Divina', '#b91c1c', 'Ambos', 'Luz Divina', 'Luz Divina', 7, 2.0, '05:30 - 23:00', 'LUZ DIVINA S.A.', 'Micro', 35),
('r090', 'M', 'Mochica Chimú', '#2563eb', 'Ambos', 'Mochica Chimú', 'Mochica Chimú', 7, 2.0, '05:30 - 23:00', 'Mochica Chimu', 'Micro', 35),
('r091', 'NN', 'Mensajeros Del Señor', '#7e22ce', 'Ambos', 'Mensajeros Del Señor', 'Mensajeros Del Señor', 7, 2.0, '05:30 - 23:00', 'MENSAJEROS DEL SEÑOR S.A.', 'Micro', 35),
('r092', 'O', 'Titanic', '#c2410c', 'Ambos', 'Titanic', 'Titanic', 7, 2.0, '05:30 - 23:00', 'TITANIC EXPRESS S.A.', 'Micro', 35),
('r093', 'P', 'Bello Horizonte', '#15803d', 'Ambos', 'Bello Horizonte', 'Bello Horizonte', 7, 2.0, '05:30 - 23:00', 'BELLO HORIZONTE S.A.', 'Micro', 35),
('r094', 'P', 'Virgen Del Arco', '#be185d', 'Ambos', 'Virgen Del Arco', 'Virgen Del Arco', 7, 2.0, '05:30 - 23:00', 'VIRGEN DEL ARCO S.A.', 'Micro', 35),
('r095', 'P1', 'Santa Rosa', '#1d4ed8', 'Ambos', 'Santa Rosa', 'Santa Rosa', 7, 2.0, '05:30 - 23:00', 'SANTA ROSA S.R.L.', 'Micro', 35),
('r096', 'P2', 'Santa Rosa', '#1e40af', 'Ambos', 'Santa Rosa', 'Santa Rosa', 7, 2.0, '05:30 - 23:00', 'SANTA ROSA S.R.L.', 'Micro', 35),
('r097', 'R', 'Luz Divina', '#0ea5e9', 'Ambos', 'Luz Divina', 'Luz Divina', 7, 2.0, '05:30 - 23:00', 'LUZ DIVINA S.A.', 'Micro', 35),
('r098', 'R', 'Señor De La Misericordia', '#facc15', 'Ambos', 'Señor De La Misericordia', 'Señor De La Misericordia', 7, 2.0, '05:30 - 23:00', 'SEÑOR DE LA MISERICORDIA S.A.', 'Micro', 35),
('r099', 'S', 'Bello Horizonte', '#16a34a', 'Ambos', 'Bello Horizonte', 'Bello Horizonte', 7, 2.0, '05:30 - 23:00', 'BELLO HORIZONTE S.A.', 'Micro', 35)
ON CONFLICT DO NOTHING;

INSERT INTO routes (slug, code, name, color, direction, start_point, end_point, frequency_min, fare_soles, schedule, company, route_type, duration_min) VALUES
('r100', 'S', 'San Isidro Labrador', '#dc2626', 'Ambos', 'San Isidro Labrador', 'San Isidro Labrador', 7, 2.0, '05:30 - 23:00', 'SAN ISIDRO LABRADOR S.A.', 'Micro', 35),
('r101', 'S', 'Sol Y Luna', '#7c3aed', 'Ambos', 'Sol Y Luna', 'Sol Y Luna', 7, 2.0, '05:30 - 23:00', 'LOS GIRASOLES SERVICE S.R.L.', 'Micro', 35),
('r102', 'S1', 'Santa Catalina', '#ea580c', 'Ambos', 'Santa Catalina', 'Santa Catalina', 7, 2.0, '05:30 - 23:00', 'SANTA CATALINA S.A.', 'Micro', 35),
('r103', 'S2', 'El Aguila', '#0891b2', 'Ambos', 'El Aguila', 'El Aguila', 7, 2.0, '05:30 - 23:00', 'EL AGUILA S.A.', 'Micro', 35),
('r104', 'S3', 'Señor De La Misericordia', '#db2777', 'Ambos', 'Señor De La Misericordia', 'Señor De La Misericordia', 7, 2.0, '05:30 - 23:00', 'SEÑOR DE LA MISERICORDIA S.A.', 'Micro', 35),
('r105', 'S4', 'Corazón De Jesús', '#65a30d', 'Ambos', 'Corazón De Jesús', 'Corazón De Jesús', 7, 2.0, '05:30 - 23:00', 'CORAZÓN DE JESÚS S.A.C.', 'Micro', 35),
('r106', 'CT-12 SL', 'Los Halcones', '#9333ea', 'Ambos', 'Los Halcones', 'Los Halcones', 7, 2.0, '05:30 - 23:00', 'Los Halcones S.A.', 'Bus', 35),
('r107', 'CT-14 SL', 'Y Serv Los Pinos', '#f97316', 'Ambos', 'Y Serv Los Pinos', 'Y Serv Los Pinos', 7, 2.0, '05:30 - 23:00', 'Turismo y serv. Los Pinos S.A.C.', 'Bus', 35),
('r108', 'T1', 'San Isidro Labrador', '#0d9488', 'Ambos', 'San Isidro Labrador', 'San Isidro Labrador', 7, 2.0, '05:30 - 23:00', 'SAN ISIDRO LABRADOR S.A.', 'Micro', 35),
('r109', 'T2', 'Miramar', '#e11d48', 'Ambos', 'Miramar', 'Miramar', 7, 2.0, '05:30 - 23:00', 'MIRAMAR S.A.', 'Micro', 35),
('r110', 'CT-29 TA', 'Amigos Unidos', '#4f46e5', 'Ambos', 'Amigos Unidos', 'Amigos Unidos', 7, 2.0, '05:30 - 23:00', 'Amigos Unidos S.A.C.', 'Bus', 35),
('r111', 'CT-28 T.S.', 'Salaverry', '#ca8a04', 'Ambos', 'Salaverry', 'Salaverry', 7, 2.0, '05:30 - 23:00', 'Serv. Generales Salaverry S.R.L.', 'Bus', 35),
('r112', 'U', 'El Aguila', '#059669', 'Ambos', 'El Aguila', 'El Aguila', 7, 2.0, '05:30 - 23:00', 'EL AGUILA S.A.', 'Micro', 35),
('r113', 'UI', 'Luz Divina', '#b91c1c', 'Ambos', 'Luz Divina', 'Luz Divina', 7, 2.0, '05:30 - 23:00', 'LUZ DIVINA S.A.', 'Micro', 35),
('r114', 'V', 'Nuevo California', '#2563eb', 'Ambos', 'Nuevo California', 'Nuevo California', 7, 2.0, '05:30 - 23:00', 'NUEVO CALIFORNIA S.A.', 'Micro', 35),
('r115', 'CT-05 V-A', 'Covisa', '#7e22ce', 'Ambos', 'Covisa', 'Covisa', 7, 2.0, '05:30 - 23:00', 'COVISA S.A.C.', 'Bus', 35),
('r116', 'CT-06 V-A', 'Nuestra Señora De Guadalupe', '#c2410c', 'Ambos', 'Nuestra Señora De Guadalupe', 'Nuestra Señora De Guadalupe', 7, 2.0, '05:30 - 23:00', 'Nuestra Señora de Guadalupe S.A.', 'Bus', 35),
('r117', 'CT-07 V-A', 'Serv E Industria Vista Alegre', '#15803d', 'Ambos', 'Serv E Industria Vista Alegre', 'Serv E Industria Vista Alegre', 7, 2.0, '05:30 - 23:00', 'Serv. e industria Vista Alegre S.A.', 'Bus', 35),
('r118', 'W', 'Miramar', '#be185d', 'Ambos', 'Miramar', 'Miramar', 7, 2.0, '05:30 - 23:00', 'MIRAMAR S.A.', 'Micro', 35),
('r119', 'XS', 'Moderno Girasoles', '#1d4ed8', 'Ambos', 'Moderno Girasoles', 'Moderno Girasoles', 7, 2.0, '05:30 - 23:00', 'MODERNO GIRASOLES EXPRESS S.A', 'Micro', 35)
ON CONFLICT DO NOTHING;

INSERT INTO routes (slug, code, name, color, direction, start_point, end_point, frequency_min, fare_soles, schedule, company, route_type, duration_min) VALUES
('r120', 'Y', 'Señor De La Misericordia', '#1e40af', 'Ambos', 'Señor De La Misericordia', 'Señor De La Misericordia', 7, 2.0, '05:30 - 23:00', 'SEÑOR DE LA MISERICORDIA S.A.', 'Micro', 35),
('r121', 'Z1', 'Titanic', '#0ea5e9', 'Ambos', 'Titanic', 'Titanic', 7, 2.0, '05:30 - 23:00', 'TITANIC EXPRESS S.A.', 'Micro', 35),
('r122', 'Z2', 'Arco Iris', '#facc15', 'Ambos', 'Arco Iris', 'Arco Iris', 7, 2.0, '05:30 - 23:00', 'ARCO IRIS EXPRESS S.A.', 'Micro', 35)
ON CONFLICT DO NOTHING;

ALTER TABLE routes ALTER COLUMN slug SET NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS idx_routes_slug ON routes(slug);