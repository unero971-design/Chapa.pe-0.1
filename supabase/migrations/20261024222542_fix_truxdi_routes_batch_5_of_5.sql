/*
# Corregir rutas 101-123 según Truxdi (lote 5 de 5, final)

1. Cambios
- Actualiza nombres al formato Truxdi "La X de Y" en 18 rutas (slugs r105–r122)
- Cambia route_type de "Bus" a "Unidad" en rutas CT-
- Truxdi catalog confirma los siguientes nombres:
  S4 Corazón de Jesús
  CT-12 SL Los Halcones
  CT-14 SL Y Serv Los Pinos
  T1 San Isidro Labrador
  T2 Miramar
  CT-29 TA Amigos Unidos
  CT-28 T.S. Salaverry (Serv. Generales Salaverry)
  U El Aguila
  UI Luz Divina
  V Nuevo California
  CT-05 V-A Covisa
  CT-06 V-A Nuestra Señora De Guadalupe
  CT-07 V-A Serv E Industria Vista Alegre
  W Miramar
  XS Moderno Girasoles
  Y Señor De La Misericordia
  Z1 Titanic
  Z2 Arco Iris

2. Seguridad
- No cambia esquema ni políticas. Solo UPDATE de datos existentes.

3. Notas
- Fuente: https://truxdi.com/trujillo/rutas (catálogo público)
- Este es el lote final que completa la corrección de todas las 123 rutas existentes.
*/

-- r105: S4, Corazón de Jesús
UPDATE routes SET name = 'La S4 de Corazón De Jesús' WHERE slug = 'r105';

-- r106: CT-12 SL, Los Halcones
UPDATE routes SET name = 'La SL de Los Halcones', route_type = 'Unidad' WHERE slug = 'r106';

-- r107: CT-14 SL, Y Serv Los Pinos
UPDATE routes SET name = 'La SL de Y Serv Los Pinos', route_type = 'Unidad' WHERE slug = 'r107';

-- r108: T1, San Isidro Labrador
UPDATE routes SET name = 'La T1 de San Isidro Labrador' WHERE slug = 'r108';

-- r109: T2, Miramar
UPDATE routes SET name = 'La T2 de Miramar' WHERE slug = 'r109';

-- r110: CT-29 TA, Amigos Unidos
UPDATE routes SET name = 'La TA de Amigos Unidos', route_type = 'Unidad' WHERE slug = 'r110';

-- r111: CT-28 T.S., Salaverry
UPDATE routes SET name = 'La T.S. de Salaverry', route_type = 'Unidad' WHERE slug = 'r111';

-- r112: U, El Aguila
UPDATE routes SET name = 'La U de El Aguila' WHERE slug = 'r112';

-- r113: UI, Luz Divina
UPDATE routes SET name = 'La UI de Luz Divina' WHERE slug = 'r113';

-- r114: V, Nuevo California
UPDATE routes SET name = 'La V de Nuevo California' WHERE slug = 'r114';

-- r115: CT-05 V-A, Covisa
UPDATE routes SET name = 'La V-A de Covisa', route_type = 'Unidad' WHERE slug = 'r115';

-- r116: CT-06 V-A, Nuestra Señora De Guadalupe
UPDATE routes SET name = 'La V-A de Nuestra Señora De Guadalupe', route_type = 'Unidad' WHERE slug = 'r116';

-- r117: CT-07 V-A, Serv E Industria Vista Alegre
UPDATE routes SET name = 'La V-A de Serv E Industria Vista Alegre', route_type = 'Unidad' WHERE slug = 'r117';

-- r118: W, Miramar
UPDATE routes SET name = 'La W de Miramar' WHERE slug = 'r118';

-- r119: XS, Moderno Girasoles
UPDATE routes SET name = 'La XS de Moderno Girasoles' WHERE slug = 'r119';

-- r120: Y, Señor De La Misericordia
UPDATE routes SET name = 'La Y de Señor De La Misericordia' WHERE slug = 'r120';

-- r121: Z1, Titanic
UPDATE routes SET name = 'La Z1 de Titanic' WHERE slug = 'r121';

-- r122: Z2, Arco Iris
UPDATE routes SET name = 'La Z2 de Arco Iris' WHERE slug = 'r122';