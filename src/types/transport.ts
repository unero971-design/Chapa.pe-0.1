// Modelo de datos de transporte para Trujillo.
// Diseñado para no asumir información desconocida como confirmada.

export type RouteMode = 'micro' | 'combi' | 'desconocida';

export type Direction = 'ida' | 'vuelta' | 'circular' | 'desconocido';

export type GeometryStatus = 'pendiente' | 'parcial' | 'verificada';

export type VerificationStatus = 'pendiente' | 'verificada';

// Posición GeoJSON en orden [longitud, latitud].
export type Position = [number, number];

export type LineStringGeometry = {
  type: 'LineString';
  coordinates: Position[];
};

export type MultiLineStringGeometry = {
  type: 'MultiLineString';
  coordinates: Position[][];
};

export type Geometry = LineStringGeometry | MultiLineStringGeometry | null;

export type StopRef = string;

export type Stop = {
  id: string;
  name: string;
  coords: { lng: number; lat: number } | null;
  source: string;
  verificationStatus: VerificationStatus;
};

export type RouteVariant = {
  id: string;
  label?: string;
  direction: Direction;
  origin?: string;
  destination?: string;
  geometry: Geometry;
  stopRefs: StopRef[];
  geometryStatus: GeometryStatus;
};

export type Route = {
  id: string;
  code?: string;
  name: string;
  company?: string;
  mode: RouteMode;
  color: string;
  variants: RouteVariant[];
  sources: string[];
  verifiedAt?: string;
};

export type TransportCatalog = {
  routes: Route[];
  stops: Stop[];
};

export const emptyCatalog: TransportCatalog = { routes: [], stops: [] };
