/*
# Corregir rutas 51-75 según Truxdi (lote 3 de 5)

1. Cambios
- Actualiza nombres al formato Truxdi "La X de Y" en 25 rutas (slugs r055–r079)
- Cambia route_type de "Bus" a "Unidad" en rutas CT-
- Actualiza start_point/end_point con calles reales donde hay datos de Truxdi
- Truxdi catalog confirma:
  C1 El Cortijo: Calle Luis Alberto Sánchez, El Porvenir → Calle Santa Clara, El Porvenir
  C1 Libertad: Alto Trujillo, El Porvenir → Calle 7, Alto Trujillo
  C2 Libertad: El Porvenir → Calle José G. Condorcanqui, Alto Trujillo
  H Huanchaco: M-06 "B" punto 01 → Avenida Ramón Castilla
  C Salaverry: M-21 A punto 01 → Avenida Albania, Alto Trujillo, fare 2.50

2. Seguridad
- No cambia esquema ni políticas. Solo UPDATE de datos existentes.

3. Notas
- Fuente: https://truxdi.com/trujillo/rutas (catálogo público)
*/

-- r055: C, Mochica
UPDATE routes SET name = 'La C de Mochica' WHERE slug = 'r055';

-- r056: C, Moderno Cielo Azul
UPDATE routes SET name = 'La C de Moderno Cielo Azul' WHERE slug = 'r056';

-- r057: C, Nuevo California
UPDATE routes SET name = 'La C de Nuevo California' WHERE slug = 'r057';

-- r058: C, Salaverry — Truxdi detail: M-21 A punto 01 → Avenida Albania, Alto Trujillo, fare 2.50
UPDATE routes SET name = 'La C de Salaverry', start_point = 'M-21 A punto 01', end_point = 'Avenida Albania, Alto Trujillo', fare_soles = 2.50 WHERE slug = 'r058';

-- r059: CT-22 C, San Pedro Del Amor
UPDATE routes SET name = 'La C de San Pedro Del Amor', route_type = 'Unidad' WHERE slug = 'r059';

-- r060: C1, El Cortijo — Truxdi: Calle Luis Alberto Sánchez, El Porvenir → Calle Santa Clara, El Porvenir
UPDATE routes SET name = 'La C1 de El Cortijo', start_point = 'Calle Luis Alberto Sánchez, El Porvenir', end_point = 'Calle Santa Clara, El Porvenir' WHERE slug = 'r060';

-- r061: C1, Libertad — Truxdi: Alto Trujillo, El Porvenir → Calle 7, Alto Trujillo
UPDATE routes SET name = 'La C1 de Libertad', start_point = 'Alto Trujillo, El Porvenir', end_point = 'Calle 7, Alto Trujillo' WHERE slug = 'r061';

-- r062: C2, El Cortijo
UPDATE routes SET name = 'La C2 de El Cortijo' WHERE slug = 'r062';

-- r063: C2, Libertad — Truxdi: El Porvenir → Calle José G. Condorcanqui, Alto Trujillo
UPDATE routes SET name = 'La C2 de Libertad', start_point = 'El Porvenir', end_point = 'Calle José G. Condorcanqui, Alto Trujillo' WHERE slug = 'r063';

-- r064: C2VR, El Cortijo
UPDATE routes SET name = 'La C2VR de El Cortijo' WHERE slug = 'r064';

-- r065: C3, El Cortijo
UPDATE routes SET name = 'La C3 de El Cortijo' WHERE slug = 'r065';

-- r066: D, El Icaro Inversionistas
UPDATE routes SET name = 'La D de El Icaro Inversionistas' WHERE slug = 'r066';

-- r067: D, Mochica
UPDATE routes SET name = 'La D de Mochica' WHERE slug = 'r067';

-- r068: D, Nuevo California
UPDATE routes SET name = 'La D de Nuevo California' WHERE slug = 'r068';

-- r069: CT-22 D, San Pedro Del Amor
UPDATE routes SET name = 'La D de San Pedro Del Amor', route_type = 'Unidad' WHERE slug = 'r069';

-- r070: D, Señor De Los Milagros
UPDATE routes SET name = 'La D de Señor De Los Milagros' WHERE slug = 'r070';

-- r071: E, Arco Iris
UPDATE routes SET name = 'La E de Arco Iris' WHERE slug = 'r071';

-- r072: CT-11 E, Rio Seco
UPDATE routes SET name = 'La E de Rio Seco', route_type = 'Unidad' WHERE slug = 'r072';

-- r073: CT-16 F, Hermelinda
UPDATE routes SET name = 'La F de Hermelinda', route_type = 'Unidad' WHERE slug = 'r073';

-- r074: CT-21 F, N 1 Florencia
UPDATE routes SET name = 'La F de N 1 Florencia', route_type = 'Unidad' WHERE slug = 'r074';

-- r075: F, Salaverry
UPDATE routes SET name = 'La F de Salaverry' WHERE slug = 'r075';

-- r076: F, Virgen Del Arco
UPDATE routes SET name = 'La F de Virgen Del Arco' WHERE slug = 'r076';

-- r077: G, Los Girasoles Service
UPDATE routes SET name = 'La G de Los Girasoles Service' WHERE slug = 'r077';

-- r078: H, Huanchaco — Truxdi: M-06 "B" punto 01 → Avenida Ramón Castilla
UPDATE routes SET name = 'La H de Huanchaco', start_point = 'M-06 "B" punto 01', end_point = 'Avenida Ramón Castilla' WHERE slug = 'r078';

-- r079: CT-17 H, Nueva Hermelinda
UPDATE routes SET name = 'La H de Nueva Hermelinda', route_type = 'Unidad' WHERE slug = 'r079';