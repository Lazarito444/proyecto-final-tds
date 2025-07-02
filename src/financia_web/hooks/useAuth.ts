'use client'
import { useAuth } from '../contexts/AuthContext';
import { useRouter } from 'next/navigation';
import { useEffect } from 'react';

/**
 * Hook para proteger rutas que requieren autenticación
 * @param redirectTo - Ruta a la que redirigir si no está autenticado
 */
export const useRequireAuth = (redirectTo: string = '/Login') => {
  const { isAuthenticated, isLoading } = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (!isLoading && !isAuthenticated) {
      router.push(redirectTo);
    }
  }, [isAuthenticated, isLoading, router, redirectTo]);

  return { isAuthenticated, isLoading };
};

/**
 * Hook para redirigir usuarios autenticados (para páginas como login/register)
 * @param redirectTo - Ruta a la que redirigir si está autenticado
 */
export const useRedirectIfAuthenticated = (redirectTo: string = '/Dashboard') => {
  const { isAuthenticated, isLoading } = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (!isLoading && isAuthenticated) {
      router.push(redirectTo);
    }
  }, [isAuthenticated, isLoading, router, redirectTo]);

  return { isAuthenticated, isLoading };
};
