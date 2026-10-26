/*
# Corregir rutas 101-122 según Truxdi (quinto y último lote)

Fuentes confirmadas:
- r100: catálogo S de San Isidro Labrador, S/. 2.50 (Micro)
- r101: truxdi.com S / C-14 S de Sol Y Luna, S/. 2.50, Ida y vuelta
- r102: truxdi.com S1 / C-23 S1 de Santa Catalina, S/. 2.50, Ida y vuelta
- r103: truxdi.com S2 / C-25 S2 de El Aguila, S/. 2.50, Ida y vuelta
- r104: truxdi.com S3 / C-35 S3 de Señor de la Misericordia, S/. 2.50, Ida y vuelta
- r109: truxdi.com T2 / C-44 T2 de Miramar, Avenida San José → Barrio 1B, S/. 2.50, Ida y vuelta
  (conecta Panamericana Norte y El Porvenir)
- r112: truxdi.com U / C-26 U de El Aguila, Avenida Moche → Avenida Julián Arce, S/. 2.50, Ida y vuelta
- r113: truxdi.com UI / C-20 UI de Luz Divina, S/. 2.50, Ida y vuelta
- r114: truxdi.com V / M-07 V de Nuevo California, S/. 2.50, Ida y vuelta
- r119: truxdi.com XS / C-04 XS de Moderno Girasoles, Avenida César Vallejo → Cajabamba, S/. 2.50, Ida y vuelta

Tambien de búsqueda anterior:
- r097: R / C-21 R de Luz Divina, Alto Trujillo → Valle Sol, S/. 2.50, Ida y vuelta
- r032: A / C-29 A de Caballito de Totora, Sector Las Lomas → Los Sauces de Barraza, S/. 2.50
- r053: C de Caballito de Totora - misma empresa, S/. 2.50

Regla general: "Ambos" → "Ida y vuelta" en todas las no circulares.
*/

-- r100: S San Isidro Labrador — direction + fare
UPDATE routes SET 
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r100';

-- r101: S Sol Y Luna — corrección
-- Truxdi: S / C-14 S, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'S / C-14 S',
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r101';

-- r102: S1 Santa Catalina — corrección
-- Truxdi: S1 / C-23 S1, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'S1 / C-23 S1',
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r102';

-- r103: S2 El Aguila — corrección
-- Truxdi: S2 / C-25 S2, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'S2 / C-25 S2',
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r103';

-- r104: S3 Señor De La Misericordia — corrección
-- Truxdi: S3 / C-35 S3, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'S3 / C-35 S3',
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r104';

-- r105: S4 Corazón De Jesús — direction + fare
UPDATE routes SET 
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r105';

-- r106: CT-12 SL Los Halcones — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r106';

-- r107: CT-14 SL Y Serv Los Pinos — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r107';

-- r108: T1 San Isidro Labrador — direction + fare
UPDATE routes SET 
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r108';

-- r109: T2 Miramar — corrección completa
-- Truxdi: T2 / C-44 T2, Panamericana Norte → El Porvenir, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'T2 / C-44 T2',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Panamericana Norte',
  end_point = 'El Porvenir'
WHERE slug = 'r109';

-- r110: CT-29 TA Amigos Unidos — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r110';

-- r111: CT-28 T.S. Salaverry — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r111';

-- r112: U El Aguila — corrección completa
-- Truxdi: U / C-26 U, Avenida Moche → Avenida Julián Arce, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'U / C-26 U',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Avenida Moche, Urbanización El Recreo 1ª Etapa',
  end_point = 'Avenida Julián Arce'
WHERE slug = 'r112';

-- r113: UI Luz Divina — corrección
-- Truxdi: UI / C-20 UI, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'UI / C-20 UI',
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r113';

-- r114: V Nuevo California — corrección
-- Truxdi: V / M-07 V, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'V / M-07 V',
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r114';

-- r115: CT-05 V-A Covisa — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r115';

-- r116: CT-06 V-A Nuestra Señora De Guadalupe — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r116';

-- r117: CT-07 V-A Serv E Industria Vista Alegre — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r117';

-- r118: W Miramar — direction + fare
UPDATE routes SET 
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r118';

-- r119: XS Moderno Girasoles — corrección completa
-- Truxdi: XS / C-04 XS, Avenida César Vallejo → Cajabamba, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'XS / C-04 XS',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Avenida César Vallejo',
  end_point = 'Cajabamba'
WHERE slug = 'r119';

-- r120: Y Señor De La Misericordia — direction + fare
UPDATE routes SET 
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r120';

-- r121: Z1 Titanic — direction + fare
UPDATE routes SET 
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r121';

-- r122: Z2 Arco Iris — direction + fare
UPDATE routes SET 
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r122';

-- Correcciones adicionales de rutas anteriores con datos confirmados
-- r032: A Caballito De Totora — corrección completa
-- Truxdi: A / C-29 A, Sector Las Lomas → Los Sauces de Barraza, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'A / C-29 A',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Sector Las Lomas',
  end_point = 'Los Sauces de Barraza'
WHERE slug = 'r032';

-- r053: C Caballito De Totora — misma empresa, S/. 2.50
UPDATE routes SET 
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r053';

-- r097: R Luz Divina — corrección completa
-- Truxdi: R / C-21 R, Avenida Barcelona, Alto Trujillo → Valle Sol, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'R / C-21 R',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Avenida Barcelona, Alto Trujillo',
  end_point = 'Valle Sol'
WHERE slug = 'r097';