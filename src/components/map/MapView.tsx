import { useEffect, useMemo, useRef, useState } from 'react';
import Map, {
  GeolocateControl,
  NavigationControl,
  Source,
  Layer,
  type MapRef,
} from 'react-map-gl/maplibre';
import '@/lib/maplibreWorker';
import { useTransportStore } from '@/stores/useTransportStore';
import {
  buildRouteLineFeatures,
  buildStopPointFeatures,
  variantBounds,
  type RouteLineCollection,
  type StopPointCollection,
} from '@/lib/geojson';

const ROUTE_LINE_LAYER_ID = 'route-lines';
const ROUTE_HIGHLIGHT_LAYER_ID = 'route-highlight';
const STOP_CIRCLE_LAYER_ID = 'stop-circles';

const ROUTES_SOURCE_ID = 'routes-source';
const STOPS_SOURCE_ID = 'stops-source';

type Props = {
  mapRef: React.MutableRefObject<MapRef | null>;
  onMapReady?: () => void;
};

export default function MapView({ mapRef, onMapReady }: Props) {
  const innerRef = useRef<MapRef>(null);
  const [mapError, setMapError] = useState<string | null>(null);
  const [mapReady, setMapReady] = useState(false);

  const catalog = useTransportStore((s) => s.catalog);
  const visibleRouteIds = useTransportStore((s) => s.visibleRouteIds);
  const selectedVariantId = useTransportStore((s) => s.selectedVariantId);
  const selectedRouteId = useTransportStore((s) => s.selectedRouteId);
  const showStops = useTransportStore((s) => s.showStops);

  const lineData = useMemo<RouteLineCollection>(
    () => buildRouteLineFeatures(catalog, visibleRouteIds, selectedVariantId),
    [catalog, visibleRouteIds, selectedVariantId],
  );

  const visibleStopIds = useMemo(() => {
    if (!showStops) return new Set<string>();
    if (selectedRouteId) {
      const route = catalog.routes.find((r) => r.id === selectedRouteId);
      const ids = new Set<string>();
      route?.variants.forEach((v) => v.stopRefs.forEach((id) => ids.add(id)));
      return ids;
    }
    return null;
  }, [showStops, selectedRouteId, catalog]);

  const stopData = useMemo<StopPointCollection>(
    () => buildStopPointFeatures(catalog, visibleStopIds),
    [catalog, visibleStopIds],
  );

  // Exponer función para ajustar el mapa a la variante seleccionada.
  useEffect(() => {
    const map = innerRef.current?.getMap();
    if (!map) return;
    (map as unknown as { fitToSelectedVariant?: () => void }).fitToSelectedVariant =
      () => {
        if (!selectedVariantId) return;
        const route = catalog.routes.find((r) =>
          r.variants.some((v) => v.id === selectedVariantId),
        );
        const variant = route?.variants.find((v) => v.id === selectedVariantId);
        if (!variant) return;
        const bounds = variantBounds(variant);
        if (!bounds) return;
        map.fitBounds(bounds, { padding: 60, duration: 600 });
      };
  }, [catalog, selectedVariantId, mapReady]);

  // Rotación e inclinación con clic derecho (comportamiento original conservado).
  useEffect(() => {
    if (!mapReady) return;
    const map = innerRef.current?.getMap();
    if (!map) return;
    const canvas = map.getCanvas();

    let rotating = false;
    let startBearing = 0;
    let startPitch = 0;
    let startX = 0;
    let startY = 0;

    const onContextMenu = (e: Event) => e.preventDefault();

    const onMouseDown = (e: MouseEvent) => {
      if (e.button !== 2) return;
      e.preventDefault();
      rotating = true;
      startBearing = map.getBearing();
      startPitch = map.getPitch();
      startX = e.clientX;
      startY = e.clientY;
      canvas.style.cursor = 'grabbing';
      window.addEventListener('mousemove', onMouseMove);
      window.addEventListener('mouseup', onMouseUp);
    };

    const onMouseMove = (e: MouseEvent) => {
      if (!rotating) return;
      const dx = e.clientX - startX;
      const dy = e.clientY - startY;
      // Eje horizontal invertido: arrastrar a la derecha gira a la izquierda.
      const newBearing = startBearing - dx * 0.2;
      map.setBearing(newBearing);
      const newPitch = Math.max(0, Math.min(60, startPitch - dy * 0.3));
      map.setPitch(newPitch);
    };

    const onMouseUp = () => {
      rotating = false;
      canvas.style.cursor = '';
      window.removeEventListener('mousemove', onMouseMove);
      window.removeEventListener('mouseup', onMouseUp);
    };

    canvas.addEventListener('contextmenu', onContextMenu);
    canvas.addEventListener('mousedown', onMouseDown);

    return () => {
      canvas.removeEventListener('contextmenu', onContextMenu);
      canvas.removeEventListener('mousedown', onMouseDown);
      window.removeEventListener('mousemove', onMouseMove);
      window.removeEventListener('mouseup', onMouseUp);
    };
  }, [mapReady]);

  return (
    <div className="relative h-full w-full overflow-hidden bg-slate-200">
      <Map
        ref={innerRef}
        initialViewState={{ longitude: -79.03, latitude: -8.11, zoom: 12 }}
        mapStyle="https://tiles.openfreemap.org/styles/liberty"
        attributionControl={{ compact: true }}
        dragRotate={false}
        onError={() => setMapError('No se pudo cargar el mapa base.')}
        onLoad={() => {
          setMapError(null);
          setMapReady(true);
          if (innerRef.current) {
            mapRef.current = innerRef.current;
          }
          onMapReady?.();
        }}
      >
        <NavigationControl position="top-right" />
        <GeolocateControl position="top-right" trackUserLocation />

        {/* Capas de rutas: líneas base + resaltado de variante seleccionada */}
        <Source id={ROUTES_SOURCE_ID} type="geojson" data={lineData}>
          <Layer
            id={ROUTE_LINE_LAYER_ID}
            type="line"
            paint={{
              'line-color': ['get', 'color'],
              'line-width': ['case', ['get', 'selected'], 6, 3],
              'line-opacity': ['case', ['get', 'selected'], 1, 0.55],
            }}
            layout={{ 'line-cap': 'round', 'line-join': 'round' }}
          />
          <Layer
            id={ROUTE_HIGHLIGHT_LAYER_ID}
            type="line"
            filter={['==', ['get', 'selected'], true]}
            paint={{
              'line-color': ['get', 'color'],
              'line-width': 8,
              'line-opacity': 0.25,
              'line-blur': 2,
            }}
            layout={{ 'line-cap': 'round', 'line-join': 'round' }}
          />
        </Source>

        {/* Capa de paraderos con coordenadas conocidas */}
        <Source id={STOPS_SOURCE_ID} type="geojson" data={stopData}>
          <Layer
            id={STOP_CIRCLE_LAYER_ID}
            type="circle"
            paint={{
              'circle-radius': 5,
              'circle-color': '#ffffff',
              'circle-stroke-width': 2,
              'circle-stroke-color': '#0f172a',
            }}
          />
        </Source>
      </Map>

      {mapError && (
        <div className="absolute left-1/2 top-5 -translate-x-1/2 rounded-xl border border-red-200 bg-white px-4 py-3 text-sm text-red-700 shadow-lg">
          {mapError}
        </div>
      )}
    </div>
  );
}
