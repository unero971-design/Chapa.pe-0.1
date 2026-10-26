import { Locate, MapPin, AlertTriangle } from 'lucide-react';
import type { GeoPosition } from '@/hooks/useGeolocation';

type Props = {
  position: GeoPosition | null;
  error: string | null;
  following: boolean;
  onToggleFollow: () => void;
};

export default function LocationPill({ position, error, following, onToggleFollow }: Props) {
  if (error) {
    return (
      <div className="flex items-center gap-2 px-3.5 py-2 rounded-full bg-red-50 border border-red-200 text-red-700 text-xs font-medium shadow-sm">
        <AlertTriangle size={14} />
        <span className="truncate max-w-[200px]">{error}</span>
      </div>
    );
  }
  if (!position) {
    return (
      <div className="flex items-center gap-2 px-3.5 py-2 rounded-full bg-slate-900 text-white text-xs font-medium shadow-sm">
        <Locate size={14} className="text-yellow-400 animate-pulse" />
        <span>Obteniendo ubicación…</span>
      </div>
    );
  }
  return (
    <button
      onClick={onToggleFollow}
      className={`flex items-center gap-2 px-3.5 py-2 rounded-full text-xs font-semibold shadow-sm transition ${
        following
          ? 'bg-blue-700 text-white border border-blue-800'
          : 'bg-white text-slate-800 border border-slate-200 hover:border-blue-300'
      }`}
    >
      <MapPin size={14} className={following ? 'text-yellow-400' : 'text-blue-700'} />
      <span>
        {position.lat.toFixed(5)}, {position.lng.toFixed(5)}
      </span>
      <span
        className={`ml-1 px-1.5 py-0.5 rounded text-[9px] uppercase tracking-wider ${
          following ? 'bg-yellow-400 text-black' : 'bg-slate-100 text-slate-500'
        }`}
      >
        {following ? 'Siguiendo' : 'Fijo'}
      </span>
    </button>
  );
}
