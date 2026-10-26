import { ArrowRight, Eye, EyeOff, MapPin, X, AlertCircle } from 'lucide-react';
import type { Route, RouteVariant, Stop } from '@/types/transport';

type Props = {
  route: Route;
  stops: Stop[];
  selectedVariantId: string | null;
  showStops: boolean;
  onSelectVariant: (id: string) => void;
  onToggleStops: () => void;
  onFitRoute: () => void;
  onClose: () => void;
};

const directionLabel: Record<RouteVariant['direction'], string> = {
  ida: 'Ida',
  vuelta: 'Vuelta',
  circular: 'Circular',
  desconocido: 'Sentido desconocido',
};

const geometryStatusLabel: Record<RouteVariant['geometryStatus'], string> = {
  pendiente: 'Recorrido pendiente de incorporar',
  parcial: 'Recorrido parcial',
  verificada: 'Recorrido verificado',
};

export default function RouteDetail({
  route,
  stops,
  selectedVariantId,
  showStops,
  onSelectVariant,
  onToggleStops,
  onFitRoute,
  onClose,
}: Props) {
  const selectedVariant =
    route.variants.find((v) => v.id === selectedVariantId) ?? route.variants[0] ?? null;

  const variantStopIds = selectedVariant
    ? new Set(selectedVariant.stopRefs)
    : new Set<string>();
  const variantStops = stops.filter((s) => variantStopIds.has(s.id));
  const hasGeometry = selectedVariant?.geometry != null;

  return (
    <div className="flex flex-col h-full bg-white">
      {/* Header */}
      <div
        className="px-5 py-5 text-white relative"
        style={{
          background: `linear-gradient(135deg, ${route.color} 0%, #0a0a0a 160%)`,
        }}
      >
        <button
          onClick={onClose}
          className="absolute top-4 right-4 p-1.5 rounded-full hover:bg-white/15 transition"
          aria-label="Cerrar"
        >
          <X size={20} />
        </button>
        <div className="flex items-center gap-3">
          <div className="w-12 h-12 rounded-xl bg-yellow-400 text-black flex items-center justify-center font-bold text-lg shadow-lg">
            {route.code ?? '—'}
          </div>
          <div>
            <h2 className="text-lg font-bold leading-tight">{route.name}</h2>
            <p className="text-white/80 text-xs mt-0.5">
              {route.company ?? 'Empresa no informada'}
            </p>
          </div>
        </div>

        <div className="mt-4 text-[11px] text-white/80">
          {route.sources.length > 0
            ? `Fuentes: ${route.sources.join(', ')}`
            : 'Sin fuente informada'}
          {route.verifiedAt ? ` · Verificada: ${route.verifiedAt}` : ''}
        </div>
      </div>

      {/* Variantes / sentidos */}
      <div className="px-5 py-4 border-b border-slate-100">
        <h3 className="text-xs font-bold uppercase tracking-wider text-slate-500 mb-2">
          Variantes
        </h3>
        <div className="flex flex-wrap gap-2">
          {route.variants.map((v) => {
            const selected = v.id === selectedVariant?.id;
            return (
              <button
                key={v.id}
                onClick={() => onSelectVariant(v.id)}
                className={`px-3 py-1.5 rounded-full text-xs font-semibold transition border ${
                  selected
                    ? 'border-slate-900 bg-slate-900 text-white'
                    : 'border-slate-200 bg-white text-slate-700 hover:border-slate-400'
                }`}
              >
                {v.label ?? directionLabel[v.direction]}
              </button>
            );
          })}
        </div>

        {selectedVariant && (
          <div className="mt-3 text-sm text-slate-700">
            <div className="flex items-center gap-1.5 text-[11px] text-slate-500 mb-1">
              <span>{directionLabel[selectedVariant.direction]}</span>
              <span>·</span>
              <span
                className={
                  selectedVariant.geometryStatus === 'verificada'
                    ? 'text-green-700'
                    : selectedVariant.geometryStatus === 'parcial'
                      ? 'text-amber-700'
                      : 'text-slate-500'
                }
              >
                {geometryStatusLabel[selectedVariant.geometryStatus]}
              </span>
            </div>
            {(selectedVariant.origin || selectedVariant.destination) && (
              <div className="flex items-center gap-2">
                <MapPin size={14} className="text-blue-700" />
                <span className="font-semibold text-slate-800">
                  {selectedVariant.origin ?? 'Origen desconocido'}
                </span>
                <ArrowRight size={12} className="text-slate-400" />
                <span className="font-semibold text-slate-800">
                  {selectedVariant.destination ?? 'Destino desconocido'}
                </span>
              </div>
            )}
          </div>
        )}
      </div>

      {/* Acciones */}
      <div className="px-5 py-3 border-b border-slate-100 flex flex-wrap gap-2">
        <button
          onClick={onFitRoute}
          disabled={!hasGeometry}
          className="px-3 py-2 rounded-lg bg-blue-700 text-white text-xs font-semibold disabled:bg-slate-300 disabled:cursor-not-allowed hover:bg-blue-800 transition"
        >
          Ver recorrido completo
        </button>
        <button
          onClick={onToggleStops}
          className="px-3 py-2 rounded-lg border border-slate-200 text-slate-700 text-xs font-semibold hover:border-slate-400 transition flex items-center gap-1.5"
        >
          {showStops ? <Eye size={14} /> : <EyeOff size={14} />}
          {showStops ? 'Ocultar paraderos' : 'Mostrar paraderos'}
        </button>
      </div>

      {/* Paraderos */}
      <div className="flex-1 overflow-y-auto px-5 py-4">
        {variantStops.length === 0 ? (
          <div className="text-center text-slate-400 text-sm flex flex-col items-center gap-2 py-8">
            <AlertCircle size={24} className="text-slate-300" />
            Paraderos no disponibles
          </div>
        ) : (
          <>
            <h3 className="text-xs font-bold uppercase tracking-wider text-slate-500 mb-3">
              Paraderos ({variantStops.length})
              {selectedVariant && selectedVariant.geometryStatus === 'parcial' && (
                <span className="ml-2 text-amber-700 normal-case font-medium">
                  · lista parcial
                </span>
              )}
            </h3>
            <ol className="space-y-0">
              {variantStops.map((s, i) => (
                <li key={s.id}>
                  <div className="w-full text-left flex gap-3 py-2.5 px-3 rounded-lg hover:bg-slate-50 transition">
                    <div className="flex flex-col items-center pt-1">
                      <div
                        className={`w-3 h-3 rounded-full border-2 ${
                          s.verificationStatus === 'verificada'
                            ? 'border-green-600 bg-white'
                            : 'border-slate-400 bg-white'
                        }`}
                      />
                      {i < variantStops.length - 1 && (
                        <div
                          className="w-0.5 flex-1 mt-1"
                          style={{ minHeight: 22, background: route.color, opacity: 0.4 }}
                        />
                      )}
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2">
                        <span className="font-medium text-slate-800 text-sm truncate">
                          {s.name}
                        </span>
                        {s.verificationStatus === 'pendiente' && (
                          <span className="text-[9px] font-bold uppercase bg-slate-100 text-slate-500 px-1.5 py-0.5 rounded">
                            Sin verificar
                          </span>
                        )}
                      </div>
                      <span className="text-[11px] text-slate-500 mt-0.5 block">
                        {s.coords
                          ? `${s.coords.lat.toFixed(5)}, ${s.coords.lng.toFixed(5)}`
                          : 'Coordenadas no disponibles'}
                      </span>
                    </div>
                  </div>
                </li>
              ))}
            </ol>
          </>
        )}
      </div>
    </div>
  );
}
