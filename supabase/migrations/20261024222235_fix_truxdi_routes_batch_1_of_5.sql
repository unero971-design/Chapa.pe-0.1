/*
# Corregir rutas 1-25 según Truxdi (lote 1 de 5)

1. Cambios
- Corrige códigos de 3 rutas con slug para coincidir con Truxdi:
  M-25 A → A (Alto Trujillo), C-29 A → A (Caballito De Totora), M-02 A → A (California)
- Actualiza nombres al formato Truxdi "La X de Y" en 24 rutas
- Cambia route_type de "Bus" a "Unidad" en rutas CT- (Truxdi las clasifica como Unidad)
- Actualiza start_point/end_point con calles reales donde hay datos de Truxdi
- Actualiza fares a 2.50 donde Truxdi confirma ese pasaje
- Actualiza direction a "Circular" donde Truxdi lo confirma

2. Seguridad
- No cambia esquema ni políticas. Solo UPDATE de datos existentes.
- RLS ya está habilitado con políticas públicas de lectura.

3. Notas
- Fuente: https://truxdi.com/trujillo/rutas y páginas de detalle individuales.
- Las rutas sin datos de start/end verificables mantienen sus valores actuales.
- Se corrigen las primeras 25 rutas (slugs a-alto-trujillo-ida, a-caballito-de-totora-ida,
  a-california-ida, ct-25-a-emp-transp-wichanzao-circular, ct-26-a-horizonte-ecologico-circular,
  r000, r006–r029).
*/

-- 1. Fix slug-named routes: codes, names, fares, route_type
UPDATE routes SET code = 'A', name = 'La A de Alto Trujillo', route_type = 'Micro' WHERE slug = 'a-alto-trujillo-ida';
UPDATE routes SET code = 'A', name = 'La A de Caballito De Totora', route_type = 'Micro' WHERE slug = 'a-caballito-de-totora-ida';
UPDATE routes SET code = 'A', name = 'La A de California', route_type = 'Micro' WHERE slug = 'a-california-ida';
UPDATE routes SET name = 'La A de Emp Transp Wichanzao', route_type = 'Unidad', direction = 'Circular' WHERE slug = 'ct-25-a-emp-transp-wichanzao-circular';
UPDATE routes SET name = 'La A de De Horizonte Ecologico', route_type = 'Unidad', direction = 'Circular' WHERE slug = 'ct-26-a-horizonte-ecologico-circular';

-- 2. Fix r000 (CT-15 A, Alfa Y Omega)
UPDATE routes SET name = 'La A de Alfa Y Omega', route_type = 'Unidad', direction = 'Circular' WHERE slug = 'r000';

-- 3. Fix r006 (A, Esperanza)
UPDATE routes SET name = 'La A de Esperanza' WHERE slug = 'r006';

-- 4. Fix r007 (CT-24 A, Esperanza Tours)
UPDATE routes SET name = 'La A de Esperanza Tours', route_type = 'Unidad' WHERE slug = 'r007';

-- 5. Fix r008 (CT-01 A, Expreso Buenos Aires)
UPDATE routes SET name = 'La A de Expreso Buenos Aires', route_type = 'Unidad' WHERE slug = 'r008';

-- 6. Fix r009 (A / M-04 A, Huanchaco)
UPDATE routes SET name = 'La A de Huanchaco' WHERE slug = 'r009';

-- 7. Fix r010 (CT-10 A, Huracan) — Truxdi detail: Circular, fare 2.00
UPDATE routes SET name = 'La A de Huracan', route_type = 'Unidad', direction = 'Circular', fare_soles = 2.00 WHERE slug = 'r010';

-- 8. Fix r011 (CT-02 A, Larco)
UPDATE routes SET name = 'La A de Larco', route_type = 'Unidad', direction = 'Circular' WHERE slug = 'r011';

-- 9. Fix r012 (A, Libertad)
UPDATE routes SET name = 'La A de Libertad' WHERE slug = 'r012';

-- 10. Fix r013 (A, Los Diamantes)
UPDATE routes SET name = 'La A de Los Diamantes' WHERE slug = 'r013';

-- 11. Fix r014 (A, Nuevo California) — Truxdi detail: Avenida Victor Larco Herrera, Buenos Aires → Carretera Panamericana Norte, fare 2.50
UPDATE routes SET name = 'La A de Nuevo California', start_point = 'Avenida Victor Larco Herrera, Buenos Aires', end_point = 'Carretera Panamericana Norte', fare_soles = 2.50 WHERE slug = 'r014';

-- 12. Fix r015 (CT-04 A, Reyna Larco) — Truxdi detail: Circular, Jirón Atahualpa, Urb. El Recreo 1ª Etapa
UPDATE routes SET name = 'La A de Reyna Larco', route_type = 'Unidad', direction = 'Circular', start_point = 'Jirón Atahualpa, Urbanización El Recreo 1ª Etapa', end_point = 'Jirón Atahualpa, Urbanización El Recreo 1ª Etapa' WHERE slug = 'r015';

-- 13. Fix r016 (A, Salaverry)
UPDATE routes SET name = 'La A de Salaverry' WHERE slug = 'r016';

-- 14. Fix r017 (A, Salaverry) — second Salaverry route
UPDATE routes SET name = 'La A de Salaverry' WHERE slug = 'r017';

-- 15. Fix r018 (CT-22 A, San Pedro Del Amor) — Truxdi detail: Circular, Calle Amazonas → Calle Amazonas, fare 2.50
UPDATE routes SET name = 'La A de San Pedro Del Amor', route_type = 'Unidad', direction = 'Circular', start_point = 'Calle Amazonas', end_point = 'Calle Amazonas', fare_soles = 2.50 WHERE slug = 'r018';

-- 16. Fix r019 (A, Señor De Los Milagros)
UPDATE routes SET name = 'La A de Señor De Los Milagros' WHERE slug = 'r019';

-- 17. Fix r020 (CT-09 A, Serv Generales Nuevo Gran Chimu)
UPDATE routes SET name = 'La A de Serv Generales Nuevo Gran Chimu', route_type = 'Unidad' WHERE slug = 'r020';

-- 18. Fix r021 (CT-23 A, Serv Multiples Moderno) — Truxdi catalog: Avenida Miguel Grau → Avenida José Gabriel Condorcanqui, La Esperanza
UPDATE routes SET name = 'La A de Serv Multiples Moderno', route_type = 'Unidad', start_point = 'Avenida Miguel Grau', end_point = 'Avenida José Gabriel Condorcanqui, La Esperanza' WHERE slug = 'r021';

-- 19. Fix r022 (CT-03 A, Victor Larco)
UPDATE routes SET name = 'La A de Victor Larco', route_type = 'Unidad' WHERE slug = 'r022';

-- 20. Fix r023 (A, Virgen De La Puerta)
UPDATE routes SET name = 'La A de Virgen De La Puerta' WHERE slug = 'r023';

-- 21. Fix r024 (A1, Señor De Los Milagros)
UPDATE routes SET name = 'La A1 de Señor De Los Milagros' WHERE slug = 'r024';

-- 22. Fix r025 (A1-B1, Señor De Los Milagros)
UPDATE routes SET name = 'La A1B1 de Señor De Los Milagros' WHERE slug = 'r025';

-- 23. Fix r026 (AB, Cesar Vallejo)
UPDATE routes SET name = 'La AB de Cesar Vallejo' WHERE slug = 'r026';

-- 24. Fix r027 (CT-23 AC, Serv Multiples Moderno) — Truxdi catalog: Avenida Nuevo Trujillo → Calle San Lucas
UPDATE routes SET name = 'La AC de Serv Multiples Moderno', route_type = 'Unidad', start_point = 'Avenida Nuevo Trujillo', end_point = 'Calle San Lucas' WHERE slug = 'r027';

-- 25. Fix r028 (CT-08 AM, Dios Es Mi Guia)
UPDATE routes SET name = 'La AM de Dios Es Mi Guia', route_type = 'Unidad' WHERE slug = 'r028';

-- 26. Fix r029 (CT-26 AU, De Horizonte Ecologico)
UPDATE routes SET name = 'La AU de De Horizonte Ecologico', route_type = 'Unidad' WHERE slug = 'r029';