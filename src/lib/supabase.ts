import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL as string;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY as string;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export type Route = {
  id: string;
  code: string;
  name: string;
  color: string;
  direction: string;
  start_point: string;
  end_point: string;
  frequency_min: number;
  fare_soles: number;
  schedule: string;
  created_at: string;
  company: string;
  route_type: string;
  duration_min: number;
  slug: string;
};

export type Stop = {
  id: string;
  route_id: string;
  name: string;
  lat: number;
  lng: number;
  order: number;
  is_major: boolean;
  created_at: string;
};

export type RouteSegment = {
  id: string;
  route_id: string;
  lat: number;
  lng: number;
  order: number;
};

export type RouteWithDetails = Route & {
  stops: Stop[];
  segments: [number, number][];
};
