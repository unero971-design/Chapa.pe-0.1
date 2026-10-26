import type { Position, RouteVariant, TransportCatalog } from '@/types/transport';

// Tipos GeoJSON mínimos para evitar dependencias adicionales.
export type LineStringGj = { type: 'LineString'; coordinates: Position[] };
export type MultiLineStringGj = { type: 'MultiLineString'; coordinates: Position[][] };
export type PointGj = { type: 'Point'; coordinates: Position };

export type RouteLineProperties = {
  routeId: string;
  variantId: string;
  color: string;
  selected: boolean;
};

export type StopPointProperties = { stopId: string; name: string };

export type RouteLineFeature = {
  type: 'Feature';
  geometry: LineStringGj | MultiLineStringGj;
  properties: RouteLineProperties;
};

export type StopPointFeature = {
  type: 'Feature';
  geometry: PointGj;
  properties: StopPointProperties;
};

export type RouteLineCollection = {
  type: 'FeatureCollection';
  features: RouteLineFeature[];
};

export type StopPointCollection = {
  type: 'FeatureCollection';
  features: StopPointFeature[];
};

export const emptyLineFeatureCollection: RouteLineCollection = {
  type: 'FeatureCollection',
  features: [],
};

export const emptyPointFeatureCollection: StopPointCollection = {
  type: 'FeatureCollection',
  features: [],
};

function variantToGeometry(v: RouteVariant): LineStringGj | MultiLineStringGj | null {
  if (!v.geometry) return null;
  if (v.geometry.type === 'LineString') {
    return { type: 'LineString', coordinates: v.geometry.coordinates };
  }
  return { type: 'MultiLineString', coordinates: v.geometry.coordinates };
}

export function buildRouteLineFeatures(
  catalog: TransportCatalog,
  visibleRouteIds: string[] | null,
  selectedVariantId: string | null,
): RouteLineCollection {
  const features: RouteLineFeature[] = [];
  const visibleSet = visibleRouteIds ? new Set(visibleRouteIds) : null;
  for (const route of catalog.routes) {
    if (visibleSet && !visibleSet.has(route.id)) continue;
    for (const v of route.variants) {
      const geom = variantToGeometry(v);
      if (!geom) continue;
      features.push({
        type: 'Feature',
        geometry: geom,
        properties: {
          routeId: route.id,
          variantId: v.id,
          color: route.color,
          selected: selectedVariantId === v.id,
        },
      });
    }
  }
  return { type: 'FeatureCollection', features };
}

export function buildStopPointFeatures(
  catalog: TransportCatalog,
  visibleStopIds: Set<string> | null,
): StopPointCollection {
  const features: StopPointFeature[] = [];
  for (const stop of catalog.stops) {
    if (!stop.coords) continue;
    if (visibleStopIds && !visibleStopIds.has(stop.id)) continue;
    features.push({
      type: 'Feature',
      geometry: { type: 'Point', coordinates: [stop.coords.lng, stop.coords.lat] },
      properties: { stopId: stop.id, name: stop.name },
    });
  }
  return { type: 'FeatureCollection', features };
}

// Bounds en formato [west, south, east, north] para maplibre fitBounds.
export function variantBounds(v: RouteVariant): [number, number, number, number] | null {
  if (!v.geometry) return null;
  const lons: number[] = [];
  const lats: number[] = [];
  if (v.geometry.type === 'LineString') {
    for (const p of v.geometry.coordinates) {
      lons.push(p[0]);
      lats.push(p[1]);
    }
  } else {
    for (const seg of v.geometry.coordinates) {
      for (const p of seg) {
        lons.push(p[0]);
        lats.push(p[1]);
      }
    }
  }
  if (lons.length === 0) return null;
  return [Math.min(...lons), Math.min(...lats), Math.max(...lons), Math.max(...lats)];
}

export function stopIdsForVariant(v: RouteVariant): Set<string> {
  return new Set(v.stopRefs);
}
