/*
# Add 2 missing OSM routes to reach 125 total

1. New Data
- Adds OSM-19934524: Operador no identificado, connects Carretera Panamericana Norte -> Calle Zarumilla, Buenos Aires. 25 total paradas.
- Adds OSM-19970876: Operador no identificado (El Cortijo S.A. referenced), connects El Porvenir, El Porvenir -> Calle Luis Alberto Sánchez, El Porvenir. 25 total paradas.
- Both routes are sourced from Truxdi's public catalog and correspond to OpenStreetMap route relations.
2. Security
- RLS already enabled on `routes` table. These rows inherit the existing public-read policies.
- No changes to policies or grants needed.
3. Important Notes
- Brings total route count from 123 to 125, matching Truxdi's catalog.
- route_type set to 'Micro' as default (no classification in source).
- fare_soles 2.00, frequency_min 7, duration_min 35 — consistent with all other routes.
*/

INSERT INTO routes (id, code, name, company, route_type, direction, start_point, end_point, fare_soles, frequency_min, duration_min, schedule, color, slug)
VALUES
  (
    gen_random_uuid(),
    'OSM-19934524',
    'OSM 19934524',
    'Operador no identificado',
    'Micro',
    'Ambos',
    'Carretera Panamericana Norte',
    'Calle Zarumilla, Buenos Aires',
    2.00,
    7,
    35,
    '05:30 - 23:00',
    '#64748b',
    'osm-19934524-operador-no-identificado-sentido'
  ),
  (
    gen_random_uuid(),
    'OSM-19970876',
    'OSM 19970876',
    'Operador no identificado',
    'Micro',
    'Ambos',
    'El Porvenir, El Porvenir',
    'Calle Luis Alberto Sánchez, El Porvenir',
    2.00,
    7,
    35,
    '05:30 - 23:00',
    '#64748b',
    'osm-19970876-operador-no-identificado-sentido'
  )
ON CONFLICT DO NOTHING;
