import type { TransportCatalog } from '@/types/transport';
import { validateCatalog } from '@/lib/transportSchemas';

// Fixture exclusivamente de desarrollo. NO es una ruta real.
// Se usa solo para probar el dibujo de geometrías y el ajuste del mapa.
// Excluida del catálogo de producción.

const fixture: unknown = {
  routes: [
    {
      id: 'PRUEBA-NO-REAL-001',
      code: 'PRUEBA',
      name: 'PRUEBA: NO ES UNA RUTA REAL',
      company: 'Fixture de desarrollo',
      mode: 'desconocida',
      color: '#94a3b8',
      sources: ['fixture de prueba'],
      variants: [
        {
          id: 'PRUEBA-NO-REAL-001-ida',
          label: 'Prueba ida',
          direction: 'ida',
          origin: 'Punto A',
          destination: 'Punto B',
          geometryStatus: 'verificada',
          stopRefs: ['PRUEBA-stop-1', 'PRUEBA-stop-2'],
          geometry: {
            type: 'LineString',
            coordinates: [
              [-79.05, -8.11],
              [-79.04, -8.115],
              [-79.03, -8.12],
            ],
          },
        },
      ],
    },
  ],
  stops: [
    {
      id: 'PRUEBA-stop-1',
      name: 'PRUEBA: paradero A',
      coords: { lng: -79.05, lat: -8.11 },
      source: 'fixture de prueba',
      verificationStatus: 'pendiente',
    },
    {
      id: 'PRUEBA-stop-2',
      name: 'PRUEBA: paradero B',
      coords: { lng: -79.03, lat: -8.12 },
      source: 'fixture de prueba',
      verificationStatus: 'pendiente',
    },
  ],
};

const result = validateCatalog(fixture);
if (!result.ok) {
  throw new Error(`Fixture de prueba inválido: ${JSON.stringify(result.errors)}`);
}

export const testFixtureCatalog: TransportCatalog = result.catalog;
