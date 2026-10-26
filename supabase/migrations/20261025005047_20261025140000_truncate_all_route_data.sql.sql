-- Borra todos los datos del catálogo de transporte (rutas, paraderos y segmentos).
-- Solicitado explícitamente el 2026-10-25. Las tablas y políticas se conservan; solo se eliminan las filas.
TRUNCATE TABLE route_segments, stops, routes RESTART IDENTITY CASCADE;
