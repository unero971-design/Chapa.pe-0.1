# Inventario y lote 1 — GTFS Trujillo (mdb-2200)

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

## Lote 1: 10 rutas importadas

Además de la ruta piloto M-20 "C" (ya importada), se incorporaron 10 rutas:

| Código     | Operador             | Sentido    | Puntos | Paraderos |
| ---------- | -------------------- | ---------- | ------: | --------: |
| C-01 "B"   | Nuevos Girasoles     | Circular   |    603 |       243 |
| C-06 "K"   | Titanic Express      | Circular   |    541 |       200 |
| M-07 "V"   | Nuevo California     | Desconocido|    627 |       203 |
| C-07 "Z1"  | Titanic Express      | Circular   |    688 |       259 |
| C-09 "E"   | Arco Iris Express    | Circular   |    599 |       208 |
| M-21 "A"   | Salaverry Express    | Circular   |    904 |       324 |
| M-22 "F"   | Salaverry Express    | Circular   |    719 |       251 |
| C-20 "UI"  | Luz Divina           | Circular   |    579 |       169 |
| C-11 "T1"  | San Isidro Labrador  | Desconocido|    470 |       154 |
| M-34 "A"   | Esperanza Express    | Circular   |    739 |       277 |

**Totales del catálogo actual**: 11 rutas, 1.430 paraderos únicos.

## Registros omitidos

Ninguno en este lote. Las 10 rutas seleccionadas tenían geometría utilizable.

## Advertencias de vigencia y calidad

1. **Modalidad desconocida**: OSM no etiqueta si es micro o combi.
2. **Paraderos no verificados**: son nodos OSM, no paraderos oficiales
   verificados en campo.
3. **Sentido "desconocido"**: 2 rutas (M-07 "V" y C-11 "T1") no son circulares
   según su nombre, pero el feed no tiene direction_id. Se etiquetaron como
   "Variante 1" en lugar de asumir ida/vuelta.
4. **Vigencia**: el feed data de noviembre 2024. No se puede confirmar que
   estos servicios operen actualmente.
5. **Paradas auto-generadas excluidas**: entre 4 y 39 por ruta.

## Proceso reproducible

```bash
# Importar un lote de rutas
node scripts/import-gtfs-batch.mjs /tmp/gtfs-trujillo/extracted \
  src/data/gtfs-batch-1.json <route_id1> <route_id2> ...

# Generar inventario completo
node scripts/gtfs-inventory.mjs /tmp/gtfs-trujillo/extracted > inventario.csv
```

El catálogo unificado `src/data/gtfs-catalog.json` se carga automáticamente
al iniciar la aplicación.
