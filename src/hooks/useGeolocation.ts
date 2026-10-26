import { useEffect, useState } from 'react';

export type GeoPosition = {
  lat: number;
  lng: number;
  accuracy: number;
  heading: number | null;
  speed: number | null;
};

export function useGeolocation(track = true) {
  const [position, setPosition] = useState<GeoPosition | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [permission, setPermission] = useState<'idle' | 'granted' | 'denied' | 'prompt'>('idle');

  useEffect(() => {
    if (!('geolocation' in navigator)) {
      setError('Geolocalización no soportada en este dispositivo');
      return;
    }
    const watchId = navigator.geolocation.watchPosition(
      (pos) => {
        setPermission('granted');
        setError(null);
        setPosition({
          lat: pos.coords.latitude,
          lng: pos.coords.longitude,
          accuracy: pos.coords.accuracy,
          heading: pos.coords.heading,
          speed: pos.coords.speed,
        });
      },
      (err) => {
        if (err.code === err.PERMISSION_DENIED) {
          setPermission('denied');
          setError('Permiso de ubicación denegado. Actívalo en tu navegador.');
        } else if (err.code === err.POSITION_UNAVAILABLE) {
          setError('Ubicación no disponible.');
        } else if (err.code === err.TIMEOUT) {
          setError('Tiempo de espera agotado al obtener ubicación.');
        } else {
          setError(err.message);
        }
      },
      { enableHighAccuracy: true, maximumAge: 5000, timeout: 15000 }
    );
    return () => navigator.geolocation.clearWatch(watchId);
  }, [track]);

  const requestPermission = () => {
    if ('permissions' in navigator) {
      navigator.permissions.query({ name: 'geolocation' as PermissionName }).then((res) => {
        setPermission(res.state as 'granted' | 'denied' | 'prompt');
      });
    }
  };

  return { position, error, permission, requestPermission };
}
