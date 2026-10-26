import { z } from 'zod';

// Validación del catálogo de transporte.
// Distingue errores estructurales (rechazan la importación) de advertencias
// de calidad (no invalidan el archivo pero se reportan).

const finiteNumber = z.number().finite();

const positionSchema = z
  .tuple([finiteNumber, finiteNumber])
  .refine(([lng, lat]) => lng >= -180 && lng <= 180, {
    message: 'Longitud fuera de rango (-180, 180)',
    path: [0],
  })
  .refine(([lng, lat]) => lat >= -90 && lat <= 90, {
    message: 'Latitud fuera de rango (-90, 90)',
    path: [1],
  });

const lineStringSchema = z.object({
  type: z.literal('LineString'),
  coordinates: z.array(positionSchema).min(2, 'LineString requiere al menos 2 posiciones'),
});

const multiLineStringSchema = z.object({
  type: z.literal('MultiLineString'),
  coordinates: z
    .array(z.array(positionSchema).min(2, 'Cada segmento requiere al menos 2 posiciones'))
    .min(1, 'MultiLineString requiere al menos un segmento'),
});

const geometrySchema = z
  .union([lineStringSchema, multiLineStringSchema])
  .nullable();

const stopSchema = z.object({
  id: z.string().min(1, 'ID de paradero vacío'),
  name: z.string().min(1, 'Nombre de paradero vacío'),
  coords: z
    .object({ lng: finiteNumber, lat: finiteNumber })
    .nullable()
    .refine(
      (c) => c === null || (c.lng >= -180 && c.lng <= 180 && c.lat >= -90 && c.lat <= 90),
      'Coordenadas de paradero fuera de rango',
    ),
  source: z.string().default('desconocida'),
  verificationStatus: z.enum(['pendiente', 'verificada']).default('pendiente'),
});

const routeVariantSchema = z.object({
  id: z.string().min(1, 'ID de variante vacío'),
  label: z.string().optional(),
  direction: z.enum(['ida', 'vuelta', 'circular', 'desconocido']),
  origin: z.string().optional(),
  destination: z.string().optional(),
  geometry: geometrySchema,
  stopRefs: z.array(z.string().min(1)),
  geometryStatus: z.enum(['pendiente', 'parcial', 'verificada']).default('pendiente'),
});

const routeSchema = z.object({
  id: z.string().min(1, 'ID de ruta vacío'),
  code: z.string().optional(),
  name: z.string().min(1, 'Nombre de ruta vacío'),
  company: z.string().optional(),
  mode: z.enum(['micro', 'combi', 'desconocida']),
  color: z
    .string()
    .regex(/^#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$/, 'Color debe ser hex (#rgb o #rrggbb)'),
  variants: z.array(routeVariantSchema).min(1, 'Una ruta necesita al menos una variante'),
  sources: z.array(z.string()).default([]),
  verifiedAt: z.string().optional(),
});

export const catalogSchema = z.object({
  routes: z.array(routeSchema),
  stops: z.array(stopSchema),
});

export type CatalogInput = z.input<typeof catalogSchema>;

// Resultado de importación: separa errores estructurales de advertencias.
export type ImportIssue = {
  kind: 'error' | 'warning';
  path: string;
  message: string;
};

export type ImportResult =
  | { ok: true; catalog: z.infer<typeof catalogSchema>; warnings: ImportIssue[] }
  | { ok: false; errors: ImportIssue[] };

function collectIssues(error: z.ZodError): ImportIssue[] {
  return error.issues.map((issue) => ({
    kind: 'error' as const,
    path: issue.path.join('.') || '(raíz)',
    message: issue.message,
  }));
}

// Validación adicional que requiere acceso a todo el catálogo:
// IDs únicos y referencias a paraderos existentes.
function validateCrossRefs(
  catalog: z.infer<typeof catalogSchema>,
): ImportIssue[] {
  const issues: ImportIssue[] = [];
  const stopIds = new Set<string>();
  catalog.stops.forEach((s) => stopIds.add(s.id));

  const routeIds = new Set<string>();
  catalog.routes.forEach((r, ri) => {
    if (routeIds.has(r.id)) {
      issues.push({
        kind: 'error',
        path: `routes[${ri}].id`,
        message: `ID de ruta duplicado: ${r.id}`,
      });
    }
    routeIds.add(r.id);

    const variantIds = new Set<string>();
    r.variants.forEach((v, vi) => {
      if (variantIds.has(v.id)) {
        issues.push({
          kind: 'error',
          path: `routes[${ri}].variants[${vi}].id`,
          message: `ID de variante duplicado: ${v.id}`,
        });
      }
      variantIds.add(v.id);

      v.stopRefs.forEach((ref, si) => {
        if (!stopIds.has(ref)) {
          issues.push({
            kind: 'error',
            path: `routes[${ri}].variants[${vi}].stopRefs[${si}]`,
            message: `Paradero referenciado no existe: ${ref}`,
          });
        }
      });
    });
  });

  catalog.stops.forEach((s, si) => {
    const seen = catalog.stops.findIndex((x) => x.id === s.id);
    if (seen !== -1 && seen < si) {
      issues.push({
        kind: 'error',
        path: `stops[${si}].id`,
        message: `ID de paradero duplicado: ${s.id}`,
      });
    }
  });

  return issues;
}

export function validateCatalog(input: unknown): ImportResult {
  const parsed = catalogSchema.safeParse(input);
  if (!parsed.success) {
    return { ok: false, errors: collectIssues(parsed.error) };
  }
  const crossIssues = validateCrossRefs(parsed.data);
  if (crossIssues.some((i) => i.kind === 'error')) {
    return { ok: false, errors: crossIssues };
  }
  return { ok: true, catalog: parsed.data, warnings: crossIssues };
}
