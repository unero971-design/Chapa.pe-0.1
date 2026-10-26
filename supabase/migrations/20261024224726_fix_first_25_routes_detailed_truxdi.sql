/*
# Corregir primeras 25 rutas según Truxdi (corrección detallada)

1. Cambios basados en páginas de detalle de Truxdi:
- a-california-ida: direction "Ida" → "Ida y vuelta"
- r016 (Salaverry M-28): code, fare 2.50, direction, start/end
- r017 (Salaverry M-21): code, fare 2.50, direction, start/end
- r019 (Señor De Los Milagros M-31): code, fare 2.50, direction, start/end
- r020 (CT-09 A Gran Chimu): direction → Circular
- r022 (CT-03 A Victor Larco): direction → Circular, start/end
- r023 (Virgen De La Puerta M-24): code, fare 2.50, direction, start/end
- r024 (A1 Señor De Los Milagros): direction → Circular, start/end
- Todas las rutas con direction "Ambos" → "Ida y vuelta"
- Códigos completos para rutas con variante M-XX conocida

2. Seguridad
- No cambia esquema ni políticas. Solo UPDATE de datos existentes.

3. Fuentes
- https://truxdi.com/trujillo/rutas/a-salaverry-express-ida-m-28
- https://truxdi.com/trujillo/rutas/a-salaverry-express-vuelta-m-21
- https://truxdi.com/trujillo/rutas/a-senor-de-los-milagros-ida
- https://truxdi.com/trujillo/rutas/ct-03-a-victor-larco-circular
- https://truxdi.com/trujillo/rutas/a-virgen-de-la-puerta-vuelta
- https://truxdi.com/trujillo/rutas/a1-senor-de-los-milagros-circular
- https://truxdi.com/trujillo/rutas/a-california-vuelta
- https://truxdi.com/trujillo/rutas (catálogo)
*/

-- 1. a-alto-trujillo-ida: code completo
UPDATE routes SET code = 'A / M-25 A' WHERE slug = 'a-alto-trujillo-ida';

-- 2. a-caballito-de-totora-ida: code completo
UPDATE routes SET code = 'A / C-29 A' WHERE slug = 'a-caballito-de-totora-ida';

-- 3. a-california-ida: code completo + direction
UPDATE routes SET code = 'A / M-02 A', direction = 'Ida y vuelta' WHERE slug = 'a-california-ida';

-- 4. ct-25-a-emp-transp-wichanzao-circular: direction ya es Circular ✓

-- 5. ct-26-a-horizonte-ecologico-circular: direction ya es Circular ✓

-- 6. r000 (CT-15 A, Alfa Y Omega): direction ya es Circular ✓

-- 7. r006 (A, Esperanza): direction Ambos → Ida y vuelta
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r006';

-- 8. r007 (CT-24 A, Esperanza Tours): direction Ambos → Ida y vuelta
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r007';

-- 9. r008 (CT-01 A, Expreso Buenos Aires): direction Ambos → Ida y vuelta
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r008';

-- 10. r009 (A / M-04 A, Huanchaco): direction Ambos → Ida y vuelta
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r009';

-- 11. r010 (CT-10 A, Huracan): direction ya es Circular ✓

-- 12. r011 (CT-02 A, Larco): direction ya es Circular ✓

-- 13. r012 (A, Libertad): direction Ambos → Ida y vuelta
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r012';

-- 14. r013 (A, Los Diamantes): direction Ambos → Ida y vuelta
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r013';

-- 15. r014 (A, Nuevo California): direction Ambos → Ida y vuelta
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r014';

-- 16. r015 (CT-04 A, Reyna Larco): direction ya es Circular ✓

-- 17. r016 (A, Salaverry M-28): corrección completa
-- Truxdi: A / M-28 A, Calle Los Geranios → Avenida Antenor Orrego, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'A / M-28 A',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Calle Los Geranios',
  end_point = 'Avenida Antenor Orrego'
WHERE slug = 'r016';

-- 18. r017 (A, Salaverry M-21): corrección completa
-- Truxdi: A / M-21 A, M-21 A punto 01 → Prolongación Avenida 12 de Noviembre, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'A / M-21 A',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'M-21 A punto 01',
  end_point = 'Prolongación Avenida 12 de Noviembre'
WHERE slug = 'r017';

-- 19. r018 (CT-22 A, San Pedro Del Amor): direction ya es Circular ✓

-- 20. r019 (A, Señor De Los Milagros M-31): corrección completa
-- Truxdi: A / M-31 A, Avenida 2 de Mayo, Vista Alegre → Calle Los Eucaliptos, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'A / M-31 A',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Avenida 2 de Mayo, Vista Alegre',
  end_point = 'Calle Los Eucaliptos'
WHERE slug = 'r019';

-- 21. r020 (CT-09 A, Serv Generales Nuevo Gran Chimu): direction → Circular
-- URL Truxdi: ct-09-a-serv-generales-nuevo-gran-chimu-circular
UPDATE routes SET direction = 'Circular' WHERE slug = 'r020';

-- 22. r021 (CT-23 A, Serv Multiples Moderno): direction Ambos → Ida y vuelta
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r021';

-- 23. r022 (CT-03 A, Victor Larco): direction → Circular, start/end corregidos
-- Truxdi: CT-03 A, Jirón Atahualpa, Urb. El Recreo 1ª Etapa → Jirón Atahualpa, Urb. El Recreo 1ª Etapa, Circular, S/. 2.00
UPDATE routes SET 
  direction = 'Circular',
  start_point = 'Jirón Atahualpa, Urbanización El Recreo 1ª Etapa',
  end_point = 'Jirón Atahualpa, Urbanización El Recreo 1ª Etapa'
WHERE slug = 'r022';

-- 24. r023 (A, Virgen De La Puerta M-24): corrección completa
-- Truxdi: A / M-24 A, Avenida América Sur → Avenida Libertad, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'A / M-24 A',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Avenida América Sur',
  end_point = 'Avenida Libertad'
WHERE slug = 'r023';

-- 25. r024 (A1, Señor De Los Milagros M-32): direction → Circular, start/end corregidos
-- Truxdi: A1 / M-32 "A1", Calle Los Rosales → Calle Los Rosales, Circular, S/. 2.00
UPDATE routes SET 
  direction = 'Circular',
  start_point = 'Calle Los Rosales',
  end_point = 'Calle Los Rosales'
WHERE slug = 'r024';