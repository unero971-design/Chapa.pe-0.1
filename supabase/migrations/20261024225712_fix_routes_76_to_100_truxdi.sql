/*
# Corregir rutas 76-100 según Truxdi (cuarto lote)

Fuentes confirmadas:
- r075: truxdi.com F / M-22 F de Salaverry, Avenida 12 de Noviembre → Avenida Juan Pablo II, S/. 2.50, Solo ida
- r076: truxdi.com F / C-17 F de Virgen Del Arco, S/. 2.50
- r077: truxdi.com G / C-34 G de Los Girasoles Service, S/. 2.50, Circular
- r078: catálogo H de Huanchaco, M-06 "B" punto 01 → Avenida Ramón Castilla, S/. 2.00 (ya correcto)
- r080: truxdi.com H / C-02 H de Nuevos Girasoles, Avenida Alan García → Avenida Federico Villarreal, S/. 2.50
- r083: catálogo H2 / C-24 "H2" de Santa Catalina, Avenida Luis Condemarín → Laredo, S/. 2.00, Circular
- r085: truxdi.com JJ / C-03 JJ de Nuevos Girasoles, S/. 2.50
- r086: truxdi.com K / C-06 K de Titanic, S/. 2.50
- r089: truxdi.com M / C-22 M de Luz Divina, Valle So → Alto Trujillo, S/. 2.50, Ida y vuelta
- r090: truxdi.com M / C-10 M de Mochica Chimú, Campiña de Moche → Avenida Los Incas, S/. 2.50, Circular
- r092: truxdi.com O / C-08 O de Titanic, S/. 2.50
- r093: truxdi.com P / C-31 P de Bello Horizonte, Avenida Prolongación Santa → Sector Huangabal, S/. 2.50
- r094: truxdi.com P / C-18 "P" de Virgen Del Arco, S/. 2.00, Circular
- r095: truxdi.com P1 / C-15 P1 de Santa Rosa, S/. 2.50
- r099: truxdi.com S / C-32 S de Bello Horizonte, S/. 2.50

Regla general: "Ambos" → "Ida y vuelta" en todas las no circulares.
*/

-- r075: F Salaverry — corrección completa
-- Truxdi: F / M-22 F, Avenida 12 de Noviembre → Avenida Juan Pablo II, S/. 2.50, Solo ida
UPDATE routes SET 
  code = 'F / M-22 F',
  fare_soles = 2.50,
  direction = 'Solo ida',
  start_point = 'Avenida 12 de Noviembre',
  end_point = 'Avenida Juan Pablo II'
WHERE slug = 'r075';

-- r076: F Virgen Del Arco — corrección
-- Truxdi: F / C-17 F, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'F / C-17 F',
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r076';

-- r077: G Los Girasoles Service — corrección
-- Truxdi: G / C-34 G, S/. 2.50, Circular (URL: g-los-girasoles-service-circular)
UPDATE routes SET 
  code = 'G / C-34 G',
  fare_soles = 2.50,
  direction = 'Circular'
WHERE slug = 'r077';

-- r078: H Huanchaco — direction (start/end ya correctos del catálogo)
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r078';

-- r079: CT-17 H Nueva Hermelinda — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r079';

-- r080: H Nuevos Girasoles — corrección completa
-- Truxdi: H / C-02 H, Avenida Alan García → Avenida Federico Villarreal, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'H / C-02 H',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Avenida Alan García',
  end_point = 'Avenida Federico Villarreal'
WHERE slug = 'r080';

-- r081: CT-19 H Serv Generales Lider — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r081';

-- r082: H1 H2 Santa Catalina — direction + fare
-- Catálogo: H1, H2 · Micro, S/. 2.00
UPDATE routes SET 
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r082';

-- r083: H2 Santa Catalina — corrección completa
-- Truxdi: H2 / C-24 "H2", Avenida Luis Condemarín → Laredo, S/. 2.00, Circular
-- (URL: h2-santa-catalina-circular)
UPDATE routes SET 
  code = 'H2 / C-24 "H2"',
  direction = 'Circular'
WHERE slug = 'r083';

-- r084: I Virgen Del Arco — corrección
-- Truxdi: I / C-16 I, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'I / C-16 I',
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r084';

-- r085: JJ Nuevos Girasoles — corrección
-- Truxdi: JJ / C-03 JJ, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'JJ / C-03 JJ',
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r085';

-- r086: K Titanic — corrección
-- Truxdi: K / C-06 K, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'K / C-06 K',
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r086';

-- r087: CT-27 L Jose Emilio Lefebvre — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r087';

-- r088: LV Nuevo California — direction + fare
UPDATE routes SET 
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r088';

-- r089: M Luz Divina — corrección completa
-- Truxdi: M / C-22 M, Valle So → Alto Trujillo, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'M / C-22 M',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Valle So',
  end_point = 'Alto Trujillo'
WHERE slug = 'r089';

-- r090: M Mochica Chimú — corrección completa
-- Truxdi: M / C-10 M, Campiña de Moche → Avenida Los Incas, S/. 2.50, Circular
UPDATE routes SET 
  code = 'M / C-10 M',
  fare_soles = 2.50,
  direction = 'Circular',
  start_point = 'Campiña de Moche',
  end_point = 'Avenida Los Incas'
WHERE slug = 'r090';

-- r091: NN Mensajeros Del Señor — direction + fare
UPDATE routes SET 
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r091';

-- r092: O Titanic — corrección
-- Truxdi: O / C-08 O, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'O / C-08 O',
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r092';

-- r093: P Bello Horizonte — corrección completa
-- Truxdi: P / C-31 P, Avenida Prolongación Santa → Sector Huangabal, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'P / C-31 P',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Avenida Prolongación Santa, Molino',
  end_point = 'Sector Huangabal'
WHERE slug = 'r093';

-- r094: P Virgen Del Arco — corrección
-- Truxdi: P / C-18 "P", S/. 2.00, Circular (URL: p-virgen-del-arco-circular)
UPDATE routes SET 
  code = 'P / C-18 "P"',
  direction = 'Circular'
WHERE slug = 'r094';

-- r095: P1 Santa Rosa — corrección
-- Truxdi: P1 / C-15 P1, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'P1 / C-15 P1',
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r095';

-- r096: P2 Santa Rosa — direction + fare
UPDATE routes SET 
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r096';

-- r097: R Luz Divina — direction + fare
UPDATE routes SET 
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r097';

-- r098: R Señor De La Misericordia — direction + fare
UPDATE routes SET 
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r098';

-- r099: S Bello Horizonte — corrección
-- Truxdi: S / C-32 S, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'S / C-32 S',
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r099';