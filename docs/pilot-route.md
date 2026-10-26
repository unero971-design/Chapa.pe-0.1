# Ruta piloto: M-20 "C" Salaverry Express

## Fuente de datos

- **Repositorio**: [trufi-association/Trujillo-OMUS](https://github.com/trufi-association/Trujillo-OMUS)
- **Feed GTFS**: [MobilityDatabase mdb-2200](https://mobilitydatabase.org/feeds/gtfs/mdb-2200)
  - "TMT Trujillo - Gerencia de Transporte"
  - URL directa: `https://files.mobilitydatabase.org/mdb-2200/mdb-2200-202411182003/mdb-2200-202411182003.zip`
  - Tamaño: 0.72 MB comprimido, 2.78 MB descomprimido
  - 102 rutas, 53617 puntos de shape, 4068 paradas
- **Origen de los datos**: OpenStreetMap (relaciones de transporte público)
- **Generador**: Scripts del repositorio Trujillo-OMUS (carpeta `GTFS-Peru-Trujillo/`)

## Licencia

- **Código del repositorio**: GPL-3.0
- **Datos de transporte**: OpenStreetMap, licencia **ODbL** (Open Database License)
  - Atribución requerida: © OpenStreetMap contributors
  - https://www.openstreetmap.org/copyright

## Fecha

- **Fecha de generación del feed GTFS**: 12 de noviembre de 2024 (feed_version)
- **Fecha de descarga**: 25 de octubre de 2026
- **Fecha de verificación en campo**: NO verificada

> La fecha de descarga NO equivale a la fecha de verificación del recorrido.
> Los datos provienen de OpenStreetMap y no han sido verificados en campo.

## Ruta importada

| Campo            | Valor                                            |
| ---------------- | ------------------------------------------------ |
| ID interno       | `osm-route-17434472`                             |
| ID de origen     | OSM relation 17434472 / GTFS route_id 17434472   |
| Código           | M-20 "C"                                         |
| Nombre           | Prolong. Av. 12 de Noviembre → Prolong. Av. 12 de Noviembre |
| Empresa          | Salaverry Express                                |
| Modalidad        | Desconocida (OSM no distingue micro/combi)      |
| Color            | #3399FF                                          |
| Sentido          | Circular                                         |
| Geometría        | LineString, 1055 puntos                          |
| Paraderos        | 349 con nombre real (nodos OSM)                  |
| Excluidos        | 30 paradas auto-generadas ("innominada" a 100m) |

## Limitaciones conocidas

1. **Paradas "innominada"**: El GTFS genera paradas automáticas cada 100m para
   sistemas informales sin paraderos fijos (configuración `fakestops` del
   generador). Estas 30 paradas se excluyeron por no ser paraderos reales.
2. **Paraderos no verificados**: Los 349 paraderos con nombre son nodos OSM.
   NO han sido verificados en campo como paraderos oficiales.
3. **Modalidad desconocida**: OSM no etiqueta si es micro o combi.
4. **Una sola variante**: Este feed tiene un trip por ruta, sin direction_id.
   No se asume ida/vuelta; se etiqueta como circular cuando origen = destino.
5. **No se inventaron**: tarifas confirmadas, frecuencias verificadas,
   horarios, duraciones, ni empresas más allá de lo que informa el feed.

## Proceso reproducible

```bash
# 1. Descargar GTFS
curl -sL -o /tmp/gtfs.zip \
  "https://files.mobilitydatabase.org/mdb-2200/mdb-2200-202411182003/mdb-2200-202411182003.zip"
unzip /tmp/gtfs.zip -d /tmp/gtfs-trujillo/extracted

# 2. Transformar una ruta al formato de la aplicación
node scripts/import-pilot-route.mjs /tmp/gtfs-trujillo/extracted 17434472 \
  src/data/pilot-route.json

# 3. El archivo src/data/pilot-route.json se carga automáticamente al iniciar
#    la aplicación (ver src/pages/TransitMapPage.tsx).
```

Para importar otras rutas, repite el paso 2 con un `route_id` diferente del
GTFS. Los IDs disponibles están en `routes.txt` del feed.
