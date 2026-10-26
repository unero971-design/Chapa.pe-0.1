import { useEffect, useRef, useState } from 'react';
import { PanelLeftClose, PanelLeftOpen, FlaskConical } from 'lucide-react';
import type { MapRef } from 'react-map-gl/maplibre';
import MapView from '@/components/map/MapView';
import RouteList from '@/components/RouteList';
import RouteDetail from '@/components/RouteDetail';
import { useTransportStore } from '@/stores/useTransportStore';
import { useGeolocation } from '@/hooks/useGeolocation';
import LocationPill from '@/components/LocationPill';
import { testFixtureCatalog } from '@/data/testFixture';
import gtfsCatalogData from '@/data/gtfs-catalog.json';

export default function TransitMapPage() {
  const mapRef = useRef<MapRef | null>(null);

  const catalog = useTransportStore((s) => s.catalog);
  const selectedRouteId = useTransportStore((s) => s.selectedRouteId);
  const selectedVariantId = useTransportStore((s) => s.selectedVariantId);
  const visibleRouteIds = useTransportStore((s) => s.visibleRouteIds);
  const showStops = useTransportStore((s) => s.showStops);
  const importCatalog = useTransportStore((s) => s.importCatalog);
  const selectRoute = useTransportStore((s) => s.selectRoute);
  const selectVariant = useTransportStore((s) => s.selectVariant);
  const setVisibleRouteIds = useTransportStore((s) => s.setVisibleRouteIds);
  const setShowStops = useTransportStore((s) => s.setShowStops);
  const clearSelection = useTransportStore((s) => s.clearSelection);

  const [query, setQuery] = useState('');
  const [panelOpen, setPanelOpen] = useState(true);
  const [following, setFollowing] = useState(false);
  const { position, error: geoError } = useGeolocation();

  // Cargar el catálogo de rutas reales (GTFS Trujillo) al iniciar.
  useEffect(() => {
    if (catalog.routes.length === 0) {
      importCatalog(gtfsCatalogData);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const selectedRoute = selectedRouteId
    ? catalog.routes.find((r) => r.id === selectedRouteId) ?? null
    : null;

  const routeStops = selectedRouteId
    ? catalog.stops.filter((s) =>
        catalog.routes
          .find((r) => r.id === selectedRouteId)
          ?.variants.some((v) => v.stopRefs.includes(s.id)),
      )
    : [];

  const toggleVisible = (id: string) => {
    const current = visibleRouteIds ?? catalog.routes.map((r) => r.id);
    const set = new Set(current);
    if (set.has(id)) set.delete(id);
    else set.add(id);
    setVisibleRouteIds(Array.from(set));
  };

  const fitRoute = () => {
    const map = mapRef.current?.getMap();
    if (!map) return;
    const fn = (map as unknown as { fitToSelectedVariant?: () => void }).fitToSelectedVariant;
    fn?.();
  };

  const loadFixture = () => {
    importCatalog(testFixtureCatalog);
    setQuery('');
  };

  return (
    <main className="relative h-full w-full flex">
      {/* Panel lateral */}
      <aside
        className={`absolute md:relative z-20 h-full bg-white shadow-lg md:shadow-none transition-all duration-300 ${
          panelOpen ? 'w-full md:w-96' : 'w-0'
        } overflow-hidden`}
      >
        <div className="h-full w-96 max-w-full flex flex-col">
          {selectedRoute ? (
            <RouteDetail
              route={selectedRoute}
              stops={routeStops}
              selectedVariantId={selectedVariantId}
              showStops={showStops}
              onSelectVariant={selectVariant}
              onToggleStops={() => setShowStops(!showStops)}
              onFitRoute={fitRoute}
              onClose={() => selectRoute(null)}
            />
          ) : (
            <RouteList
              routes={catalog.routes}
              selectedId={selectedRouteId}
              visibleRouteIds={visibleRouteIds}
              query={query}
              onQuery={setQuery}
              onSelect={selectRoute}
              onToggleVisible={toggleVisible}
              onClear={clearSelection}
            />
          )}
        </div>
      </aside>

      {/* Botón para abrir/cerrar panel en móvil */}
      <button
        onClick={() => setPanelOpen(!panelOpen)}
        className="absolute top-3 left-3 z-30 md:hidden p-2 rounded-lg bg-white shadow-md text-slate-700"
        aria-label={panelOpen ? 'Cerrar panel' : 'Abrir panel'}
      >
        {panelOpen ? <PanelLeftClose size={18} /> : <PanelLeftOpen size={18} />}
      </button>

      {/* Mapa */}
      <div className="flex-1 relative">
        <MapView mapRef={mapRef} />

        {/* Píldora de ubicación */}
        <div className="absolute top-3 right-3 z-10">
          <LocationPill
            position={position}
            error={geoError}
            following={following}
            onToggleFollow={() => setFollowing(!following)}
          />
        </div>

        {/* Botón de fixture de prueba (solo cuando catálogo vacío) */}
        {catalog.routes.length === 0 && (
          <button
            onClick={loadFixture}
            className="absolute bottom-4 left-1/2 -translate-x-1/2 z-10 flex items-center gap-2 px-4 py-2 rounded-full bg-slate-900 text-white text-xs font-semibold shadow-lg hover:bg-slate-800 transition"
            title="Cargar geometría de prueba (no es una ruta real)"
          >
            <FlaskConical size={14} className="text-yellow-400" />
            Cargar geometría de prueba
          </button>
        )}
      </div>
    </main>
  );
}
