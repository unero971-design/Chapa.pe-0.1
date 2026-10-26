import { Search, Bus, ChevronRight, Eye, EyeOff } from 'lucide-react';
import type { Route } from '@/types/transport';

type Props = {
  routes: Route[];
  selectedId: string | null;
  visibleRouteIds: string[] | null;
  query: string;
  onQuery: (q: string) => void;
  onSelect: (id: string) => void;
  onToggleVisible: (id: string) => void;
  onClear: () => void;
};

const modeLabel: Record<Route['mode'], string> = {
  micro: 'Micro',
  combi: 'Combi',
  desconocida: 'Modalidad desconocida',
};

export default function RouteList({
  routes,
  selectedId,
  visibleRouteIds,
  query,
  onQuery,
  onSelect,
  onToggleVisible,
  onClear,
}: Props) {
  const q = query.toLowerCase();
  const filtered = routes.filter(
    (r) =>
      r.name.toLowerCase().includes(q) ||
      (r.code ?? '').toLowerCase().includes(q) ||
      (r.company ?? '').toLowerCase().includes(q),
  );
  const visibleSet = visibleRouteIds ? new Set(visibleRouteIds) : null;

  return (
    <div className="flex flex-col h-full bg-white">
      <div className="px-4 pt-4 pb-3 border-b border-slate-100">
        <div className="flex items-center gap-2 mb-3">
          <div className="w-9 h-9 rounded-lg bg-blue-700 flex items-center justify-center">
            <Bus size={18} className="text-yellow-400" />
          </div>
          <div>
            <h1 className="font-bold text-slate-900 leading-tight">TrujilloTransporte</h1>
            <p className="text-[11px] text-slate-500">Rutas y paraderos · La Libertad</p>
          </div>
        </div>
        <div className="relative">
          <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
          <input
            value={query}
            onChange={(e) => onQuery(e.target.value)}
            placeholder="Buscar por código, nombre o empresa..."
            className="w-full pl-9 pr-3 py-2.5 rounded-lg bg-slate-100 text-sm text-slate-800 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:bg-white transition"
          />
        </div>
      </div>

      <div className="flex-1 overflow-y-auto">
        {filtered.length === 0 ? (
          <div className="p-6 text-center text-slate-400 text-sm">
            {routes.length === 0
              ? 'Todavía no hay rutas cargadas'
              : `No se encontraron rutas para "${query}"`}
          </div>
        ) : (
          <ul className="divide-y divide-slate-50">
            {filtered.map((r) => {
              const active = r.id === selectedId;
              const isVisible = visibleSet === null || visibleSet.has(r.id);
              const hasGeometry = r.variants.some((v) => v.geometry != null);
              return (
                <li key={r.id}>
                  <div
                    className={`w-full text-left px-4 py-3.5 flex items-center gap-3 transition ${
                      active ? 'bg-blue-50' : 'hover:bg-slate-50'
                    }`}
                  >
                    <button
                      onClick={() => onSelect(r.id)}
                      className="flex items-center gap-3 flex-1 min-w-0"
                    >
                      <div
                        className="w-11 h-11 rounded-xl flex items-center justify-center font-bold text-xs text-white shadow-sm shrink-0"
                        style={{ background: r.color }}
                      >
                        {r.code ?? '—'}
                      </div>
                      <div className="flex-1 min-w-0 text-left">
                        <div className="font-semibold text-slate-800 text-sm truncate">
                          {r.name}
                        </div>
                        <div className="text-[11px] text-slate-500 mt-0.5 truncate">
                          {modeLabel[r.mode]}
                          {r.company ? ` · ${r.company}` : ''}
                        </div>
                        <div className="text-[11px] text-slate-400 mt-0.5">
                          {r.variants.length}{' '}
                          {r.variants.length === 1 ? 'variante' : 'variantes'}
                          {!hasGeometry && ' · recorrido pendiente'}
                        </div>
                      </div>
                    </button>
                    <button
                      onClick={() => onToggleVisible(r.id)}
                      className="p-1.5 rounded-md text-slate-400 hover:text-slate-700 hover:bg-slate-100 transition shrink-0"
                      aria-label={isVisible ? 'Ocultar ruta' : 'Mostrar ruta'}
                      title={isVisible ? 'Ocultar en el mapa' : 'Mostrar en el mapa'}
                    >
                      {isVisible ? <Eye size={16} /> : <EyeOff size={16} />}
                    </button>
                  </div>
                </li>
              );
            })}
          </ul>
        )}
      </div>

      <div className="px-4 py-2.5 border-t border-slate-100 bg-slate-50/60 flex items-center justify-between">
        <p className="text-[10px] text-slate-400">
          {routes.length} {routes.length === 1 ? 'ruta' : 'rutas'} en catálogo
        </p>
        {(selectedId || visibleRouteIds) && (
          <button
            onClick={onClear}
            className="text-[11px] font-semibold text-blue-700 hover:text-blue-900 transition"
          >
            Limpiar selección
          </button>
        )}
      </div>
    </div>
  );
}

// Re-exportado para satisfacer importaciones tipo ChevronRight si se requiere.
export { ChevronRight };
