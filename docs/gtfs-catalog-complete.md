# Catálogo GTFS Trujillo — Importación completa (mdb-2200)

## Identificación del GTFS

- **Feed**: mdb-2200 "TMT Trujillo - Gerencia de Transporte"
- **URL**: https://files.mobilitydatabase.org/mdb-2200/mdb-2200-202411182003/mdb-2200-202411182003.zip
- **Origen**: OpenStreetMap (ODbL), generado por Trujillo-OMUS (GPL-3.0)
- **Fecha de generación del feed**: 12 de noviembre de 2024
- **Fecha de descarga**: 25 de octubre de 2026

## Inventario completo

| Métrica                              | Valor |
| ------------------------------------ | ----- |
| route_id únicos en routes.txt        | 102   |
| Rutas con geometría utilizable       | 102   |
| Rutas sin geometría                  | 0     |
| Shapes distintas                     | 102   |
| Shapes referenciadas por trips       | 102   |
| Trips totales                        | 102   |
| Stops en stops.txt                   | 4.067 |
| Stop_times                           | 20.170 |
| calendar_dates.txt                   | No existe |
| Período de servicio (calendar.txt)   | 2000-01-01 a 2100-01-01 (genérico, no informativo) |

### Estructura del feed

- **1 trip por ruta**: cada route_id tiene exactamente un trip y una shape.
  No hay direction_id ni múltiples variantes por ruta en este feed.
- **Servicio**: un único service_id "Mo-Su" (lunes a domingo) con rango de
  fechas genérico 2000–2100. No permite determinar vigencia actual.
- **Paradas auto-generadas**: el feed incluye paradas "innominada" generadas
  automáticamente cada ~100m (configuración `fakestops` del generador GTFS).
  Estas se excluyen de la importación por no ser paraderos reales.

> El período de servicio genérico (2000–2100) no confirma que el servicio
> esté activo actualmente. Los datos son de noviembre 2024 y no han sido
> verificados en campo.

## Importación: 102 rutas

Todas las rutas disponibles en el GTFS fueron importadas:

- **Rutas importadas**: 102 (las 102 disponibles en el feed)
- **Paraderos únicos**: 3.707 (nodos OSM con nombre real)
- **Paradas auto-generadas excluidas**: variable por ruta (4 a 39)
- **Rutas omitidas**: 0
- **Registros sin geometría**: 0

### Distribución por operador

Las 102 rutas pertenecen a múltiples operadores, incluyendo: Salaverry
Express, Nuevos Girasoles, Titanic Express, Mochica Chimu, Luz Divina,
Esperanza Express, Virgen de la Puerta, Santa Catalina, Arco Iris Express,
San Isidro Labrador, entre otros.

## Advertencias de vigencia y calidad

1. **Modalidad desconocida**: OSM no etiqueta si es micro o combi.
2. **Paraderos no verificados**: son nodos OSM, no paraderos oficiales
   verificados en campo.
3. **Sentido**: la mayoría son circulares (origen = destino). Las rutas no
   circulares se etiquetaron como "Variante 1" con sentido "desconocido"
   porque el feed no tiene direction_id.
4. **Vigencia**: el feed data de noviembre 2024. No se puede confirmar que
   estos servicios operen actualmente.
5. **No es un catálogo oficial completo de Trujillo**: son las rutas
   disponibles en esta fuente (OpenStreetMap vía Trufi/OMUS).

## Proceso reproducible

```bash
# Generar inventario completo
node scripts/gtfs-inventory.mjs /tmp/gtfs-trujillo/extracted > inventario.csv

# Importar todas las rutas
node scripts/import-gtfs-batch.mjs /tmp/gtfs-trujillo/extracted \
  src/data/gtfs-batch-all.json $(cat remaining-route-ids.txt | tr '\n' ' ')

# Fusionar con catálogo existente (ver comando en historial)
```

El catálogo unificado `src/data/gtfs-catalog.json` se carga automáticamente
al iniciar la aplicación.
