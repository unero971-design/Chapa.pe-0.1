# Formato de importación de catálogo de transporte

Este documento describe el formato JSON para importar rutas y paraderos a
TrujilloTransporte. El catálogo real se mantiene inicialmente vacío; este
formato es la vía para incorporar datos reales posteriormente.

## Estructura general

```json
{
  "routes": [ ... ],
  "stops": [ ... ]
}
```

- `routes`: catálogo de rutas y sus variantes.
- `stops`: catálogo independiente de paraderos. Las variantes referencian
  paraderos por ID, sin duplicarlos.

## Reglas importantes

- Los IDs de rutas, variantes y paraderos deben ser **únicos**.
- Las referencias `stopRefs` deben apuntar a paraderos existentes en `stops`.
- Las coordenadas GeoJSON van en orden **[longitud, latitud]**.
- Longitud entre -180 y 180. Latitud entre -90 y 90.
- `LineString` requiere al menos 2 posiciones.
- `MultiLineString` requiere al menos un segmento, cada uno con 2+ posiciones.
- Una variante sin geometría (`geometry: null`) es válida: aparece en el
  catálogo pero no se dibuja.
- No se asume que toda ruta tiene ida y vuelta. No se genera automáticamente
  la vuelta invirtiendo la ida.
- Los campos opcionales omitidos no se tratan como confirmados.

## Campos

### Route

| Campo        | Tipo     | Obligatorio | Descripción                                  |
| ------------ | -------- | ----------- | -------------------------------------------- |
| id           | string   | sí          | ID estable y único                           |
| code         | string   | no          | Código de la ruta, si se conoce              |
| name         | string   | sí          | Nombre                                       |
| company      | string   | no          | Empresa, si se conoce                        |
| mode         | enum     | sí          | `micro`, `combi` o `desconocida`             |
| color        | string   | sí          | Color hex (`#rgb` o `#rrggbb`)               |
| variants     | array    | sí          | Al menos una variante                        |
| sources      | string[] | no          | Fuentes de información                       |
| verifiedAt   | string   | no          | Fecha de verificación (ISO 8601)             |

### RouteVariant

| Campo           | Tipo     | Obligatorio | Descripción                                            |
| --------------- | -------- | ----------- | ------------------------------------------------------ |
| id              | string   | sí          | ID único de variante                                   |
| label           | string   | no          | Etiqueta legible                                       |
| direction       | enum     | sí          | `ida`, `vuelta`, `circular` o `desconocido`            |
| origin          | string   | no          | Origen, si se conoce                                   |
| destination     | string   | no          | Destino, si se conoce                                  |
| geometry        | object   | no          | GeoJSON LineString/MultiLineString o `null`            |
| stopRefs        | string[] | no          | IDs de paraderos en orden                              |
| geometryStatus  | enum     | no          | `pendiente` (defecto), `parcial` o `verificada`        |

### Stop

| Campo               | Tipo    | Obligatorio | Descripción                                  |
| ------------------- | ------- | ----------- | -------------------------------------------- |
| id                  | string  | sí          | ID único                                     |
| name                | string  | sí          | Nombre del paradero                          |
| coords              | object  | no          | `{ lng, lat }` o `null` si no se conoce      |
| source              | string  | no          | Fuente de la información                     |
| verificationStatus  | enum    | no          | `pendiente` (defecto) o `verificada`         |

## Ejemplo ilustrativo (NO es una ruta real)

> **Este ejemplo es exclusivamente ilustrativo.** No representa una ruta
> operativa. Úsalo como plantilla de formato, no como dato de producción.

```json
{
  "routes": [
    {
      "id": "ejemplo-ruta-001",
      "code": "EJ",
      "name": "EJEMPLO: ruta ilustrativa",
      "company": "Empresa de ejemplo",
      "mode": "micro",
      "color": "#0ea5e9",
      "sources": ["fuente de ejemplo"],
      "verifiedAt": "2026-01-01",
      "variants": [
        {
          "id": "ejemplo-ruta-001-ida",
          "label": "Ida",
          "direction": "ida",
          "origin": "Punto de ejemplo A",
          "destination": "Punto de ejemplo B",
          "geometryStatus": "verificada",
          "stopRefs": ["ejemplo-stop-1", "ejemplo-stop-2"],
          "geometry": {
            "type": "LineString",
            "coordinates": [
              [-79.05, -8.11],
              [-79.04, -8.115],
              [-79.03, -8.12]
            ]
          }
        }
      ]
    },
    {
      "id": "ejemplo-ruta-002",
      "code": "EJ2",
      "name": "EJEMPLO: ruta sin geometría",
      "mode": "combi",
      "color": "#f59e0b",
      "sources": ["fuente de ejemplo"],
      "variants": [
        {
          "id": "ejemplo-ruta-002-ida",
          "direction": "desconocido",
          "geometryStatus": "pendiente",
          "stopRefs": [],
          "geometry": null
        }
      ]
    }
  ],
  "stops": [
    {
      "id": "ejemplo-stop-1",
      "name": "EJEMPLO: paradero A",
      "coords": { "lng": -79.05, "lat": -8.11 },
      "source": "fuente de ejemplo",
      "verificationStatus": "pendiente"
    },
    {
      "id": "ejemplo-stop-2",
      "name": "EJEMPLO: paradero B",
      "coords": { "lng": -79.03, "lat": -8.12 },
      "source": "fuente de ejemplo",
      "verificationStatus": "pendiente"
    },
    {
      "id": "ejemplo-stop-3",
      "name": "EJEMPLO: paradero sin coordenadas",
      "coords": null,
      "source": "fuente de ejemplo",
      "verificationStatus": "pendiente"
    }
  ]
}
```

## Errores vs. advertencias

La importación distingue dos tipos de problemas:

- **Errores estructurales**: IDs duplicados, referencias rotas, coordenadas
  fuera de rango, geometrías mal formadas, campos obligatorios faltantes.
  Rechazan toda la importación; el catálogo actual no se reemplaza.
- **Advertencias de calidad**: una geometría con formato válido no implica que
  el recorrido haya sido verificado en la realidad. El campo
  `geometryStatus` y `verificationStatus` reflejan esto por separado.

Cada error reporta el registro y campo afectado (por ejemplo
`routes[2].variants[0].stopRefs[3]`).
