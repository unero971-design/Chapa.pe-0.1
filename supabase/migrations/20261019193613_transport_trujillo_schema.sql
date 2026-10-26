/*
# Esquema de transporte público de Trujillo

1. Tablas nuevas
- `routes` — rutas de transporte público (micros/buses) en Trujillo.
  - id (uuid, pk)
  - code (text) — código corto (ej. "A1", "R02")
  - name (text) — nombre descriptivo de la ruta
  - color (text) — color de línea en mapa (hex)
  - direction (text) — sentido (Ida/Vuelta/Ambos)
  - start_point (text) — punto de inicio
  - end_point (text) — punto de término
  - frequency_min (int) — frecuencia aproximada en minutos
  - fare_soles (numeric) — tarifa en soles
  - schedule (text) — horario de operación
  - created_at (timestamptz)
- `stops` — paradas de micro/bus.
  - id (uuid, pk)
  - route_id (uuid, fk → routes)
  - name (text) — nombre de la parada
  - lat (numeric) — latitud
  - lng (numeric) — longitud
  - order (int) — orden dentro de la ruta
  - is_major (bool) — parada importante/terminal
  - created_at (timestamptz)
- `route_segments` — polilíneas de las rutas (puntos para dibujar el recorrido).
  - id (uuid, pk)
  - route_id (uuid, fk → routes)
  - lat (numeric), lng (numeric), order (int)

2. Seguridad
- App sin login (datos públicos para todos los usuarios).
- RLS habilitado en todas las tablas.
- Políticas SELECT públicas (anon + authenticated) — los datos son intencionalmente públicos.
- Sin INSERT/UPDATE/DELETE públicas (los datos se gestionan vía migrations / admin futuro).

3. Notas
- Coordenadas aprox. en Trujillo, Perú (-8.11, -79.03).
- Datos de demostración con rutas reales (A, B, C) y paradas en avenidas principales.
*/

CREATE TABLE IF NOT EXISTS routes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text NOT NULL,
  name text NOT NULL,
  color text NOT NULL DEFAULT '#1e40af',
  direction text NOT NULL DEFAULT 'Ambos',
  start_point text NOT NULL,
  end_point text NOT NULL,
  frequency_min int NOT NULL DEFAULT 10,
  fare_soles numeric(5,2) NOT NULL DEFAULT 1.00,
  schedule text NOT NULL DEFAULT '05:30 - 23:00',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE routes ENABLE ROW LEVEL SECURITY;

CREATE TABLE IF NOT EXISTS stops (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  route_id uuid NOT NULL REFERENCES routes(id) ON DELETE CASCADE,
  name text NOT NULL,
  lat numeric NOT NULL,
  lng numeric NOT NULL,
  "order" int NOT NULL DEFAULT 0,
  is_major boolean NOT NULL DEFAULT false,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE stops ENABLE ROW LEVEL SECURITY;

CREATE TABLE IF NOT EXISTS route_segments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  route_id uuid NOT NULL REFERENCES routes(id) ON DELETE CASCADE,
  lat numeric NOT NULL,
  lng numeric NOT NULL,
  "order" int NOT NULL DEFAULT 0
);

ALTER TABLE route_segments ENABLE ROW LEVEL SECURITY;

-- Índices útiles
CREATE INDEX IF NOT EXISTS idx_stops_route_id ON stops(route_id);
CREATE INDEX IF NOT EXISTS idx_stops_order ON stops(route_id, "order");
CREATE INDEX IF NOT EXISTS idx_segments_route_id ON route_segments(route_id);
CREATE INDEX IF NOT EXISTS idx_segments_order ON route_segments(route_id, "order");

-- Políticas públicas de solo lectura (single-tenant, datos compartidos)
DROP POLICY IF EXISTS "public_read_routes" ON routes;
CREATE POLICY "public_read_routes" ON routes
  FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "public_read_stops" ON stops;
CREATE POLICY "public_read_stops" ON stops
  FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "public_read_route_segments" ON route_segments;
CREATE POLICY "public_read_route_segments" ON route_segments
  FOR SELECT TO anon, authenticated USING (true);

-- Datos semilla: rutas de transporte de Trujillo
INSERT INTO routes (code, name, color, direction, start_point, end_point, frequency_min, fare_soles, schedule) VALUES
('A1', 'Av. América Sur - Centro Histórico', '#1e40af', 'Ida', 'Av. América Sur', 'Plaza de Armas', 8, 1.20, '05:30 - 23:00'),
('A2', 'Av. España - Larco', '#0ea5e9', 'Ida', 'Av. España', 'Av. Larco', 10, 1.20, '05:30 - 22:30'),
('B1', 'California - Mansiche', '#facc15', 'Ida', 'Av. California', 'Mansiche', 12, 1.00, '06:00 - 22:00'),
('C1', 'Av. Del Ejército - Huanchaco', '#334155', 'Ambos', 'Av. Del Ejército', 'Huanchaco', 15, 2.50, '05:00 - 21:30'),
('D1', 'El Porvenir - Trujillo Centro', '#16a34a', 'Ida', 'El Porvenir', 'Av. España', 9, 1.20, '05:30 - 23:00'),
('E1', 'Moche - Trujillo', '#dc2626', 'Ambos', 'Moche', 'Plaza de Armas', 20, 2.00, '05:30 - 21:00')
ON CONFLICT DO NOTHING;

-- Paradas y segmentos para cada ruta (coordenadas aproximadas de Trujillo)
-- Ruta A1: Av. América Sur -> Centro Histórico
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Parque Industrial', -8.1210, -79.0350, 1, true FROM routes WHERE code='A1';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Av. América Sur / Av. César Vallejo', -8.1180, -79.0355, 2, false FROM routes WHERE code='A1';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Av. América Sur / Av. Sánchez Carrión', -8.1150, -79.0350, 3, false FROM routes WHERE code='A1';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Óvalo Grau', -8.1110, -79.0350, 4, true FROM routes WHERE code='A1';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Jr. Gamarra', -8.1095, -79.0340, 5, false FROM routes WHERE code='A1';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Plaza de Armas', -8.1081, -79.0330, 6, true FROM routes WHERE code='A1';

INSERT INTO route_segments (route_id, lat, lng, "order") SELECT id, lat, lng, ord FROM routes r, (VALUES
  (-8.1210, -79.0350, 1), (-8.1180, -79.0355, 2), (-8.1150, -79.0350, 3),
  (-8.1110, -79.0350, 4), (-8.1095, -79.0340, 5), (-8.1081, -79.0330, 6)
) AS v(lat, lng, ord) WHERE r.code='A1';

-- Ruta A2: Av. España -> Av. Larco
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Av. España / Av. Santa', -8.1090, -79.0340, 1, false FROM routes WHERE code='A2';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Av. España / Jr. Orbegoso', -8.1095, -79.0320, 2, false FROM routes WHERE code='A2';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Óvalo El Porky', -8.1100, -79.0290, 3, true FROM routes WHERE code='A2';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Av. Larco / Av. Santa', -8.1110, -79.0270, 4, false FROM routes WHERE code='A2';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Av. Larco / CC Real Plaza', -8.1130, -79.0250, 5, true FROM routes WHERE code='A2';

INSERT INTO route_segments (route_id, lat, lng, "order") SELECT id, lat, lng, ord FROM routes r, (VALUES
  (-8.1090, -79.0340, 1), (-8.1095, -79.0320, 2), (-8.1100, -79.0290, 3),
  (-8.1110, -79.0270, 4), (-8.1130, -79.0250, 5)
) AS v(lat, lng, ord) WHERE r.code='A2';

-- Ruta B1: California -> Mansiche
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Av. California / Av. Tingo María', -8.1170, -79.0280, 1, false FROM routes WHERE code='B1';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Av. California / Av. América Sur', -8.1140, -79.0280, 2, true FROM routes WHERE code='B1';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Av. Mansiche / Av. América Sur', -8.1100, -79.0300, 3, false FROM routes WHERE code='B1';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Mansiche', -8.1075, -79.0300, 4, true FROM routes WHERE code='B1';

INSERT INTO route_segments (route_id, lat, lng, "order") SELECT id, lat, lng, ord FROM routes r, (VALUES
  (-8.1170, -79.0280, 1), (-8.1140, -79.0280, 2), (-8.1100, -79.0300, 3), (-8.1075, -79.0300, 4)
) AS v(lat, lng, ord) WHERE r.code='B1';

-- Ruta C1: Av. Del Ejército -> Huanchaco
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Av. Del Ejército / Larco', -8.1110, -79.0240, 1, false FROM routes WHERE code='C1';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Av. Del Ejército / Av. Húsares', -8.1090, -79.0200, 2, true FROM routes WHERE code='C1';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Huanchaco - Entrada', -8.0900, -79.0000, 3, true FROM routes WHERE code='C1';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Huanchaco - Muelle', -8.0880, -78.9980, 4, true FROM routes WHERE code='C1';

INSERT INTO route_segments (route_id, lat, lng, "order") SELECT id, lat, lng, ord FROM routes r, (VALUES
  (-8.1110, -79.0240, 1), (-8.1090, -79.0200, 2), (-8.1000, -79.0150, 3),
  (-8.0900, -79.0000, 4), (-8.0880, -78.9980, 5)
) AS v(lat, lng, ord) WHERE r.code='C1';

-- Ruta D1: El Porvenir -> Trujillo Centro
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'El Porvenir - Mercado', -8.1250, -79.0250, 1, true FROM routes WHERE code='D1';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Av. América Sur / El Porvenir', -8.1220, -79.0300, 2, false FROM routes WHERE code='D1';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Óvalo Grau', -8.1110, -79.0350, 3, true FROM routes WHERE code='D1';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Av. España / Jr. Pizarro', -8.1090, -79.0340, 4, false FROM routes WHERE code='D1';

INSERT INTO route_segments (route_id, lat, lng, "order") SELECT id, lat, lng, ord FROM routes r, (VALUES
  (-8.1250, -79.0250, 1), (-8.1220, -79.0300, 2), (-8.1110, -79.0350, 3), (-8.1090, -79.0340, 4)
) AS v(lat, lng, ord) WHERE r.code='D1';

-- Ruta E1: Moche -> Trujillo
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Moche - Plaza', -8.1550, -79.0700, 1, true FROM routes WHERE code='E1';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Moche - Carretera', -8.1400, -79.0600, 2, false FROM routes WHERE code='E1';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Buenos Aires', -8.1300, -79.0500, 3, false FROM routes WHERE code='E1';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Av. España / Salaverry', -8.1150, -79.0380, 4, false FROM routes WHERE code='E1';
INSERT INTO stops (route_id, name, lat, lng, "order", is_major) SELECT id, 'Plaza de Armas', -8.1081, -79.0330, 5, true FROM routes WHERE code='E1';

INSERT INTO route_segments (route_id, lat, lng, "order") SELECT id, lat, lng, ord FROM routes r, (VALUES
  (-8.1550, -79.0700, 1), (-8.1400, -79.0600, 2), (-8.1300, -79.0500, 3),
  (-8.1150, -79.0380, 4), (-8.1081, -79.0330, 5)
) AS v(lat, lng, ord) WHERE r.code='E1';
