/*
# Corregir rutas 26-50 según Truxdi (lote 2 de 5)

1. Cambios
- Actualiza nombres al formato Truxdi "La X de Y" en 25 rutas (slugs r030–r054)
- Cambia route_type de "Bus" a "Unidad" en rutas CT-
- Actualiza start_point/end_point con calles reales donde hay datos de Truxdi
- Truxdi catalog confirma: CT-24 B y CT-23 B → Avenida Nicolás de Piérola, Santa Inés → Avenida Jesús de Nazareth, El Recreo
- CT-23 BC → Avenida Cardenales → La Esperanza

2. Seguridad
- No cambia esquema ni políticas. Solo UPDATE de datos existentes.

3. Notas
- Fuente: https://truxdi.com/trujillo/rutas (catálogo público)
*/

-- r030: CT-24 AU, Esperanza Tours
UPDATE routes SET name = 'La AU de Esperanza Tours', route_type = 'Unidad' WHERE slug = 'r030';

-- r031: B, Alto Trujillo
UPDATE routes SET name = 'La B de Alto Trujillo' WHERE slug = 'r031';

-- r032: B, Caballito De Totora
UPDATE routes SET name = 'La B de Caballito De Totora' WHERE slug = 'r032';

-- r033: B, California
UPDATE routes SET name = 'La B de California' WHERE slug = 'r033';

-- r034: CT-26 B, De Horizonte Ecologico
UPDATE routes SET name = 'La B de De Horizonte Ecologico', route_type = 'Unidad' WHERE slug = 'r034';

-- r035: CT-25 B, Emp Transp Wichanzao
UPDATE routes SET name = 'La B de Emp Transp Wichanzao', route_type = 'Unidad' WHERE slug = 'r035';

-- r036: B, Esperanza
UPDATE routes SET name = 'La B de Esperanza' WHERE slug = 'r036';

-- r037: CT-24 B, Esperanza Tours — Truxdi: Av. Nicolás de Piérola, Sta Inés → Av. Jesús de Nazareth, El Recreo
UPDATE routes SET name = 'La B de Esperanza Tours', route_type = 'Unidad', start_point = 'Avenida Nicolás de Piérola, Urbanización Santa Inés', end_point = 'Avenida Jesús de Nazareth, Urbanización El Recreo 1ª Etapa' WHERE slug = 'r037';

-- r038: B, Huanchaco
UPDATE routes SET name = 'La B de Huanchaco' WHERE slug = 'r038';

-- r039: CT-10 B, Huracan
UPDATE routes SET name = 'La B de Huracan', route_type = 'Unidad' WHERE slug = 'r039';

-- r040: B, Nuevos Girasoles
UPDATE routes SET name = 'La B de Nuevos Girasoles' WHERE slug = 'r040';

-- r041: B, Ramiro Priale
UPDATE routes SET name = 'La B de Ramiro Priale' WHERE slug = 'r041';

-- r042: CT-22 B, San Pedro Del Amor
UPDATE routes SET name = 'La B de San Pedro Del Amor', route_type = 'Unidad' WHERE slug = 'r042';

-- r043: B, Santa Lucia De Moche
UPDATE routes SET name = 'La B de Santa Lucia De Moche' WHERE slug = 'r043';

-- r044: CT-23 B, Serv Multiples Moderno — Truxdi: Av. Nicolás de Piérola, Sta Inés → Av. Jesús de Nazareth, El Recreo
UPDATE routes SET name = 'La B de Serv Multiples Moderno', route_type = 'Unidad', start_point = 'Avenida Nicolás de Piérola, Urbanización Santa Inés', end_point = 'Avenida Jesús de Nazareth, Urbanización El Recreo 1ª Etapa' WHERE slug = 'r044';

-- r045: B, Virgen De La Puerta
UPDATE routes SET name = 'La B de Virgen De La Puerta' WHERE slug = 'r045';

-- r046: B1, Moderno Girasoles
UPDATE routes SET name = 'La B1 de Moderno Girasoles' WHERE slug = 'r046';

-- r047: B1, Nuevo California
UPDATE routes SET name = 'La B1 de Nuevo California' WHERE slug = 'r047';

-- r048: B2, Los Girasoles Service
UPDATE routes SET name = 'La B2 de Los Girasoles Service' WHERE slug = 'r048';

-- r049: BC, Nuevo California
UPDATE routes SET name = 'La BC de Nuevo California' WHERE slug = 'r049';

-- r050: CT-23 BC, Serv Multiples Moderno — Truxdi: Avenida Cardenales → La Esperanza
UPDATE routes SET name = 'La BC de Serv Multiples Moderno', route_type = 'Unidad', start_point = 'Avenida Cardenales', end_point = 'La Esperanza' WHERE slug = 'r050';

-- r051: CT-26 BU, De Horizonte Ecologico
UPDATE routes SET name = 'La BU de De Horizonte Ecologico', route_type = 'Unidad' WHERE slug = 'r051';

-- r052: C, Bello Horizonte
UPDATE routes SET name = 'La C de Bello Horizonte' WHERE slug = 'r052';

-- r053: C, Caballito De Totora
UPDATE routes SET name = 'La C de Caballito De Totora' WHERE slug = 'r053';

-- r054: C, California
UPDATE routes SET name = 'La C de California' WHERE slug = 'r054';