/*
# Corregir rutas 26-50 según Truxdi (segundo lote)

Fuentes confirmadas:
- r025: truxdi.com/trujillo/rutas/a1-b1-senor-de-los-milagros-ida
- r026: truxdi.com/trujillo/rutas/ab-cesar-vallejo-circular
- r031: truxdi.com/trujillo/rutas/b-alto-trujillo-ida
- r036: truxdi.com/trujillo/rutas/b-corazon-esperanza-express-circular
- r039: truxdi.com/trujillo/rutas/ct-10-b-huracan-circular
- r044: truxdi.com/trujillo/rutas/ct-23-b-serv-multiples-moderno-express-circular
- r045: truxdi.com/trujillo/rutas/b-corazon-virgen-de-la-puerta-circular
- r049: truxdi.com/trujillo/rutas/bc-nuevo-california-ida
- Catálogo: truxdi.com/trujillo/rutas (r027, r037, r044 start/end confirmados)

Regla general: "Ambos" → "Ida y vuelta" en todas las rutas no circulares.
*/

-- r025: A1B1 Señor De Los Milagros — corrección completa
-- Truxdi: A1-B1 / M-32 A1-B1, Sector Nuevo Indoamérica → Buenos Aires Sur, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'A1-B1 / M-32 A1-B1',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Calle Los Rosales',
  end_point = 'Prolongación Avenida Bolivia, Vista Alegre'
WHERE slug = 'r025';

-- r026: AB Cesar Vallejo — corrección parcial
-- Truxdi: AB / M-27 AB, Circular, S/. 2.50 (URL: ab-cesar-vallejo-circular)
UPDATE routes SET 
  code = 'AB / M-27 AB',
  fare_soles = 2.50,
  direction = 'Circular'
WHERE slug = 'r026';

-- r027: CT-23 AC Serv Multiples Moderno — direction
-- Catálogo: Avenida Nuevo Trujillo -> Calle San Lucas, S/. 2.00 (start/end ya correctos)
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r027';

-- r028: CT-08 AM Dios Es Mi Guia — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r028';

-- r029: CT-26 AU Horizonte Ecologico — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r029';

-- r030: CT-24 AU Esperanza Tours — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r030';

-- r031: B Alto Trujillo — corrección completa
-- Truxdi: B / M-26 B, Calle 7, Alto Trujillo → Alto Trujillo, El Porvenir, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'B / M-26 B',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Calle 7, Alto Trujillo',
  end_point = 'Alto Trujillo, El Porvenir'
WHERE slug = 'r031';

-- r032: B Caballito De Totora — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r032';

-- r033: B California — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r033';

-- r034: CT-26 B Horizonte Ecologico — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r034';

-- r035: CT-25 B Wichanzao — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r035';

-- r036: B Esperanza (variante circular) — corrección completa
-- Truxdi: B / M-33 "B", Calle San Judas Tadeo → Calle San Judas Tadeo, S/. 2.00, Circular
UPDATE routes SET 
  code = 'B / M-33 "B"',
  direction = 'Circular',
  start_point = 'Calle San Judas Tadeo',
  end_point = 'Calle San Judas Tadeo'
WHERE slug = 'r036';

-- r037: CT-24 B Esperanza Tours — direction
-- Catálogo: Avenida Nicolás de Piérola, Santa Inés → Avenida Jesús de Nazareth, El Recreo, S/. 2.00 (start/end ya correctos)
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r037';

-- r038: B Huanchaco — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r038';

-- r039: CT-10 B Huracan — corrección completa
-- Truxdi: CT-10 B, Circular, S/. 2.00, Avenida Albania → Avenida las Magnolias, Alto Trujillo
UPDATE routes SET 
  direction = 'Circular',
  start_point = 'Avenida Albania, Alto Trujillo',
  end_point = 'Avenida las Magnolias, Alto Trujillo'
WHERE slug = 'r039';

-- r040: B Nuevos Girasoles — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r040';

-- r041: B Ramiro Priale — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r041';

-- r042: CT-22 B San Pedro Del Amor — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r042';

-- r043: B Santa Lucia De Moche — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r043';

-- r044: CT-23 B Serv Multiples Moderno — direction a Circular
-- Truxdi URL: ct-23-b-serv-multiples-moderno-express-circular
-- Catálogo: Avenida Nicolás de Piérola, Santa Inés → Avenida Jesús de Nazareth, El Recreo, S/. 2.00 (start/end ya correctos)
UPDATE routes SET direction = 'Circular' WHERE slug = 'r044';

-- r045: B Virgen De La Puerta — corrección completa
-- Truxdi: B / M-23 "B", Avenida Roma, Santa Inés → Avenida Roma, Santa Inés, S/. 2.00, Circular
UPDATE routes SET 
  code = 'B / M-23 "B"',
  direction = 'Circular',
  start_point = 'Avenida Roma, Urbanización Santa Inés',
  end_point = 'Avenida Roma, Urbanización Santa Inés'
WHERE slug = 'r045';

-- r046: B1 Moderno Girasoles — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r046';

-- r047: B1 Nuevo California — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r047';

-- r048: B2 Los Girasoles Service — direction
UPDATE routes SET direction = 'Ida y vuelta' WHERE slug = 'r048';

-- r049: BC Nuevo California — corrección completa
-- Truxdi: BC / M-09 BC, Avenida Libertad → Avenida San Pedro, S/. 2.50, Ida y vuelta
UPDATE routes SET 
  code = 'BC / M-09 BC',
  fare_soles = 2.50,
  direction = 'Ida y vuelta',
  start_point = 'Avenida Libertad',
  end_point = 'Avenida San Pedro'
WHERE slug = 'r049';