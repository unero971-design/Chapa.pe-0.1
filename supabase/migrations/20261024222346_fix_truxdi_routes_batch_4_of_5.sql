/*
# Corregir rutas 76-100 según Truxdi (lote 4 de 5)

1. Cambios
- Actualiza nombres al formato Truxdi "La X de Y" en 25 rutas (slugs r080–r104)
- Cambia route_type de "Bus" a "Unidad" en rutas CT-
- Actualiza start_point/end_point con calles reales donde hay datos de Truxdi
- Truxdi catalog confirma:
  H2 Santa Catalina: Avenida Luis Condemarín → Laredo
  M Mochica Chimú: Avenida los Incas → Plaza Miguel Grau, Urbanización El Recreo 1ª Etapa

2. Seguridad
- No cambia esquema ni políticas. Solo UPDATE de datos existentes.

3. Notas
- Fuente: https://truxdi.com/trujillo/rutas (catálogo público)
*/

-- r080: H, Nuevos Girasoles
UPDATE routes SET name = 'La H de Nuevos Girasoles' WHERE slug = 'r080';

-- r081: CT-19 H, Serv Generales Lider
UPDATE routes SET name = 'La H de Serv Generales Lider', route_type = 'Unidad' WHERE slug = 'r081';

-- r082: H1, H2, Santa Catalina
UPDATE routes SET name = 'La H1 H2 de Santa Catalina' WHERE slug = 'r082';

-- r083: H2, Santa Catalina — Truxdi: Avenida Luis Condemarín → Laredo
UPDATE routes SET name = 'La H2 de Santa Catalina', start_point = 'Avenida Luis Condemarín', end_point = 'Laredo' WHERE slug = 'r083';

-- r084: I, Virgen Del Arco
UPDATE routes SET name = 'La I de Virgen Del Arco' WHERE slug = 'r084';

-- r085: JJ, Nuevos Girasoles
UPDATE routes SET name = 'La JJ de Nuevos Girasoles' WHERE slug = 'r085';

-- r086: K, Titanic
UPDATE routes SET name = 'La K de Titanic' WHERE slug = 'r086';

-- r087: CT-27 L, Jose Emilio Lefebvre
UPDATE routes SET name = 'La L de Jose Emilio Lefebvre', route_type = 'Unidad' WHERE slug = 'r087';

-- r088: LV, Nuevo California
UPDATE routes SET name = 'La LV de Nuevo California' WHERE slug = 'r088';

-- r089: M, Luz Divina
UPDATE routes SET name = 'La M de Luz Divina' WHERE slug = 'r089';

-- r090: M, Mochica Chimú — Truxdi: Avenida los Incas → Plaza Miguel Grau, Urbanización El Recreo 1ª Etapa
UPDATE routes SET name = 'La M de Mochica Chimú', start_point = 'Avenida los Incas', end_point = 'Plaza Miguel Grau, Urbanización El Recreo 1ª Etapa' WHERE slug = 'r090';

-- r091: NN, Mensajeros Del Señor
UPDATE routes SET name = 'La NN de Mensajeros Del Señor' WHERE slug = 'r091';

-- r092: O, Titanic
UPDATE routes SET name = 'La O de Titanic' WHERE slug = 'r092';

-- r093: P, Bello Horizonte
UPDATE routes SET name = 'La P de Bello Horizonte' WHERE slug = 'r093';

-- r094: P, Virgen Del Arco
UPDATE routes SET name = 'La P de Virgen Del Arco' WHERE slug = 'r094';

-- r095: P1, Santa Rosa
UPDATE routes SET name = 'La P1 de Santa Rosa' WHERE slug = 'r095';

-- r096: P2, Santa Rosa
UPDATE routes SET name = 'La P2 de Santa Rosa' WHERE slug = 'r096';

-- r097: R, Luz Divina
UPDATE routes SET name = 'La R de Luz Divina' WHERE slug = 'r097';

-- r098: R, Señor De La Misericordia
UPDATE routes SET name = 'La R de Señor De La Misericordia' WHERE slug = 'r098';

-- r099: S, Bello Horizonte
UPDATE routes SET name = 'La S de Bello Horizonte' WHERE slug = 'r099';

-- r100: S, San Isidro Labrador
UPDATE routes SET name = 'La S de San Isidro Labrador' WHERE slug = 'r100';

-- r101: S, Sol Y Luna
UPDATE routes SET name = 'La S de Sol Y Luna' WHERE slug = 'r101';

-- r102: S1, Santa Catalina
UPDATE routes SET name = 'La S1 de Santa Catalina' WHERE slug = 'r102';

-- r103: S2, El Aguila
UPDATE routes SET name = 'La S2 de El Aguila' WHERE slug = 'r103';

-- r104: S3, Señor De La Misericordia
UPDATE routes SET name = 'La S3 de Señor De La Misericordia' WHERE slug = 'r104';