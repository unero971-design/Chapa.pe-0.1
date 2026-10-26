import { create } from 'zustand';
import type { TransportCatalog } from '@/types/transport';
import type { ImportResult } from '@/lib/transportSchemas';
import { validateCatalog } from '@/lib/transportSchemas';

type TransportState = {
  catalog: TransportCatalog;
  selectedRouteId: string | null;
  selectedVariantId: string | null;
  visibleRouteIds: string[] | null;
  showStops: boolean;
  importResult: ImportResult | null;
  selectRoute: (id: string | null) => void;
  selectVariant: (id: string | null) => void;
  setVisibleRouteIds: (ids: string[] | null) => void;
  setShowStops: (show: boolean) => void;
  importCatalog: (input: unknown) => ImportResult;
  clearImportResult: () => void;
  clearSelection: () => void;
};

export const useTransportStore = create<TransportState>((set, get) => ({
  catalog: { routes: [], stops: [] },
  selectedRouteId: null,
  selectedVariantId: null,
  visibleRouteIds: null,
  showStops: true,
  importResult: null,

  selectRoute: (id) =>
    set((state) => {
      if (id === null) {
        return { selectedRouteId: null, selectedVariantId: null };
      }
      const route = state.catalog.routes.find((r) => r.id === id);
      const firstVariant = route?.variants[0]?.id ?? null;
      return { selectedRouteId: id, selectedVariantId: firstVariant };
    }),

  selectVariant: (id) => set({ selectedVariantId: id }),

  setVisibleRouteIds: (ids) => set({ visibleRouteIds: ids }),

  setShowStops: (showStops) => set({ showStops }),

  importCatalog: (input) => {
    const result = validateCatalog(input);
    if (result.ok) {
      set({ catalog: result.catalog, importResult: result });
    } else {
      set({ importResult: result });
    }
    return result;
  },

  clearImportResult: () => set({ importResult: null }),

  clearSelection: () =>
    set({ selectedRouteId: null, selectedVariantId: null, visibleRouteIds: null }),
}));
