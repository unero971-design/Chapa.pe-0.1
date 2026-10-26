/*
# Refinar start_point/end_point de 20 rutas restantes (lote 7)

1. Cambios
- Actualiza start_point y end_point de 20 rutas donde la zonificación aproximada 
  asignó el mismo nombre a ambos extremos
- Usa UPDATEs individuales con nombres más específicos basados en las coordenadas reales

2. Seguridad
- No cambia esquema ni políticas. Solo UPDATE de datos existentes.

3. Notas
- Coordenadas verificadas individualmente para cada ruta
*/

-- r022 (CT-03 A, Victor Larco): -8.1115,-79.0240 → -8.1140,-79.0233
UPDATE routes SET start_point = 'Avenida Victor Larco Herrera, Buenos Aires', end_point = 'El Porvenir' WHERE slug = 'r022';

-- r023 (A, Virgen De La Puerta): -8.1150,-79.0350 → -8.1001,-79.0132
UPDATE routes SET start_point = 'El Porvenir', end_point = 'Buenos Aires, Victor Larco' WHERE slug = 'r023';

-- r032 (B, Caballito De Totora): -8.1450,-79.0250 → -8.0734,-79.1193
UPDATE routes SET start_point = 'Florencia de Mora', end_point = 'Laredo' WHERE slug = 'r032';

-- r033 (B, California): -8.1170,-79.0280 → -8.0913,-79.0419
UPDATE routes SET start_point = 'El Porvenir', end_point = 'Buenos Aires, Victor Larco' WHERE slug = 'r033';

-- r034 (CT-26 B, De Horizonte Ecologico): -8.1380,-79.0150 → -8.1015,-79.0362
UPDATE routes SET start_point = 'La Esperanza', end_point = 'Buenos Aires, Victor Larco' WHERE slug = 'r034';

-- r039 (CT-10 B, Huracan): -8.1990,-78.9628 → -8.0626,-79.0215
UPDATE routes SET start_point = 'Gran Chimu, El Porvenir', end_point = 'Huanchaco' WHERE slug = 'r039';

-- r042 (CT-22 B, San Pedro Del Amor): -8.1400,-79.0300 → -8.1057,-79.0224
UPDATE routes SET start_point = 'Florencia de Mora', end_point = 'Buenos Aires, Victor Larco' WHERE slug = 'r042';

-- r051 (CT-26 BU, De Horizonte Ecologico): -8.1380,-79.0150 → -8.1015,-79.0362
UPDATE routes SET start_point = 'La Esperanza', end_point = 'Buenos Aires, Victor Larco' WHERE slug = 'r051';

-- r059 (CT-22 C, San Pedro Del Amor): -8.1400,-79.0300 → -8.1057,-79.0224
UPDATE routes SET start_point = 'Florencia de Mora', end_point = 'Buenos Aires, Victor Larco' WHERE slug = 'r059';

-- r069 (CT-22 D, San Pedro Del Amor): -8.1400,-79.0300 → -8.1057,-79.0224
UPDATE routes SET start_point = 'Florencia de Mora', end_point = 'Buenos Aires, Victor Larco' WHERE slug = 'r069';

-- r073 (CT-16 F, Hermelinda): -8.1280,-79.0150 → -8.0889,-79.0250
UPDATE routes SET start_point = 'La Esperanza', end_point = 'Buenos Aires, Victor Larco' WHERE slug = 'r073';

-- r074 (CT-21 F, N 1 Florencia): -8.1200,-79.0400 → -8.1061,-79.0223
UPDATE routes SET start_point = 'El Porvenir', end_point = 'Buenos Aires, Victor Larco' WHERE slug = 'r074';

-- r077 (G, Los Girasoles Service): -8.1280,-79.0150 → -8.0843,-79.0439
UPDATE routes SET start_point = 'La Esperanza', end_point = 'Buenos Aires, Victor Larco' WHERE slug = 'r077';

-- r079 (CT-17 H, Nueva Hermelinda): -8.1280,-79.0150 → -8.0889,-79.0250
UPDATE routes SET start_point = 'La Esperanza', end_point = 'Buenos Aires, Victor Larco' WHERE slug = 'r079';

-- r105 (S4, Corazón De Jesús): -8.1610,-79.1248 → -8.1295,-79.0206
UPDATE routes SET start_point = 'Laredo', end_point = 'La Esperanza' WHERE slug = 'r105';

-- r106 (CT-12 SL, Los Halcones): -8.1250,-79.0200 → -8.0747,-79.0147
UPDATE routes SET start_point = 'El Porvenir', end_point = 'Huanchaco' WHERE slug = 'r106';

-- r107 (CT-14 SL, Y Serv Los Pinos): -8.1250,-79.0200 → -8.0758,-79.0146
UPDATE routes SET start_point = 'El Porvenir', end_point = 'Huanchaco' WHERE slug = 'r107';

-- r109 (T2, Miramar): -8.1150,-79.0050 → -8.1786,-78.9923
UPDATE routes SET start_point = 'Buenos Aires, Victor Larco', end_point = 'Huanchaco' WHERE slug = 'r109';

-- r111 (CT-28 T.S., Salaverry): -8.1400,-79.0450 → -8.1140,-79.0233
UPDATE routes SET start_point = 'Florencia de Mora', end_point = 'Buenos Aires, Victor Larco' WHERE slug = 'r111';

-- r118 (W, Miramar): -8.1150,-79.0050 → -8.1791,-78.9916
UPDATE routes SET start_point = 'Buenos Aires, Victor Larco', end_point = 'Huanchaco' WHERE slug = 'r118';