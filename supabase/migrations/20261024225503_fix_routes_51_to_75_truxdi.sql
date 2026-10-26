/*
# Corregir rutas 51-75 según Truxdi (tercer lote)

Fuentes confirmadas:
- r050: catálogo - CT-23 BC, Avenida Cardenales -> La Esperanza, S/. 2.00
- r052: truxdi.com C / C-30 C de Bello Horizonte, S/. 2.50
- r053: truxdi.com C de Caballito De Totora (sin confirmar - mantener direction fix)
- r054: truxdi.com C / M-01 C de California, Avenida Manuel Seoane → Via Panamericana Norte, S/. 2.50
- r055: truxdi.com C de Mochica - en realidad es C / C-45 C operada por LOS DIAMANTES (no MOCHICA)
  - Pero en nuestra DB es MOCHICA S.A. → buscar la correcta
- r056: truxdi.com C / M-16 C de Moderno Cielo Azul, Calle 8 → Avenida Vallejo, S/. 2.50
- r057: truxdi.com C / M-12 C de Nuevo California, Via Panamericana Norte → Avenida Libertad, S/. 2.50
- r058: truxdi.com C / M-20 C de Salaverry, Avenida 12 de Noviembre → Sector Nuevo Horizonte, S/. 2.50
- r060: catálogo - C2VR El Cortijo, Calle Luis Alberto Sánchez → Calle Santa Clara, S/. 2.00
- r061: catálogo - C1 Libertad, Alto Trujillo → Calle 7, Alto Trujillo, S/. 2.00
- r063: catálogo - C2 Libertad, El Porvenir → Calle José G. Condorcanqui, Alto Trujillo, S/. 2.00
- r064: catálogo - C2VR El Cortijo, Calle Luis Alberto Sánchez → Calle Santa Clara, S/. 2.00
- r066: truxdi.com D / M-35 D de El Icaro Inversionistas, S/. 2.50
- r067: truxdi.com D / C-13 D de Mochica, Avenida 12 de Noviembre → Calle Miguel Graú, S/. 2.50
- r070: truxdi.com D / M-30 D de Señor De Los Milagros, Calle César Vallejo → Calle 11, S/. 2.50

Regla general: "Ambos" → "Ida y vuelta" en todas las no circulares.
*/

-- r050: CT-23 BC Serv Multiples Moderno — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r050';

-- r051: CT-26 BU Horizonte Ecologico — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r051';

-- r052: C Bello Horizonte — corrección completa
-- Truxdi: C / C-30 C, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'C / C-30 C',
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r052';

-- r053: C Caballito De Totora — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r053';

-- r054: C California — corrección completa
-- Truxdi: C / M-01 C, Avenida Manuel Seoane → Via Panamericana Norte, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'C / M-01 C',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Avenida Manuel Seoane',
  end_point = 'Via Panamericana Norte'
WHERE slug = 'r054';

-- r055: C Mochica — direction + fare (pendiente confirmar código exacto)
UPDATE routes SET 
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r055';

-- r056: C Moderno Cielo Azul — corrección completa
-- Truxdi: C / M-16 C, Calle 8 → Avenida Vallejo, S/. 2.50, Ida y vuelta
-- (de búsqueda anterior: conecta Calle 8, Covicorti y Avenida Ricardo Palma)
UPDATE routes SET 
  code = 'C / M-16 C',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Calle 8, Covicorti',
  end_point = 'Avenida Ricardo Palma'
WHERE slug = 'r056';

-- r057: C Nuevo California — corrección completa
-- Truxdi: C / M-12 C, Via Panamericana Norte → Avenida Libertad, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'C / M-12 C',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Via Panamericana Norte',
  end_point = 'Avenida Libertad'
WHERE slug = 'r057';

-- r058: C Salaverry — corrección completa
-- Truxdi: C / M-20 C, Avenida 12 de Noviembre → Sector Nuevo Horizonte, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'C / M-20 C',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Avenida 12 de Noviembre',
  end_point = 'Sector Nuevo Horizonte'
WHERE slug = 'r058';

-- r059: CT-22 C San Pedro Del Amor — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r059';

-- r060: C1 El Cortijo — direction
-- Catálogo: Calle Luis Alberto Sánchez → Calle Santa Clara (ya correcto)
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r060';

-- r061: C1 Libertad — direction
-- Catálogo: Alto Trujillo → Calle 7, Alto Trujillo (ya correcto)
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r061';

-- r062: C2 El Cortijo — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r062';

-- r063: C2 Libertad — direction
-- Catálogo: El Porvenir → Calle José G. Condorcanqui, Alto Trujillo (ya correcto)
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r063';

-- r064: C2VR El Cortijo — corrección completa
-- Catálogo: C2VR · Micro, Calle Luis Alberto Sánchez → Calle Santa Clara, S/. 2.00
UPDATE routes SET 
  direction = 'Ida y vuelta',
  start_point = 'Calle Luis Alberto Sánchez, El Porvenir',
  end_point = 'Calle Santa Clara, El Porvenir'
WHERE slug = 'r064';

-- r065: C3 El Cortijo — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r065';

-- r066: D El Icaro Inversionistas — corrección completa
-- Truxdi: D / M-35 D, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'D / M-35 D',
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r066';

-- r067: D Mochica — corrección completa
-- Truxdi: D / C-13 D, Avenida 12 de Noviembre → Calle Miguel Graú, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'D / C-13 D',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Avenida 12 de Noviembre',
  end_point = 'Calle Miguel Graú'
WHERE slug = 'r067';

-- r068: D Nuevo California — direction + fare (pendiente confirmar)
UPDATE routes SET 
  fare_soles = 2.50,
  direction = 'Ida y vuelta'
WHERE slug = 'r068';

-- r069: CT-22 D San Pedro Del Amor — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r069';

-- r070: D Señor De Los Milagros — corrección completa
-- Truxdi: D / M-30 D, Calle César Vallejo → Calle 11, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'D / M-30 D',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Calle César Vallejo',
  end_point = 'Calle 11'
WHERE slug = 'r070';

-- r071: E Arco Iris — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r071';

-- r072: CT-11 E Rio Seco — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r072';

-- r073: CT-16 F Hermelinda — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r073';

-- r074: CT-21 F N° 1 Florencia — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r074';