import React from 'react';
import type { ReactNode } from 'react';
import { Navigate, useLocation } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';


interface ProtectedRouteProps {
  children: ReactNode;
}

const ProtectedRoute= ({ children }:ProtectedRouteProps) => {
  const { isAuthenticated, isLoading } = useAuth();
  const location = useLocation();

  if (isLoading) {
    // Puedes personalizar este loading spinner
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-[rgb(31,133,119)]"></div>
      </div>
    );
  }

  if (!isAuthenticated) {
    // Redirigir al login y guardar la ubicación actual
    return <Navigate to="/login" state={{ from: location }} replace />;
  }

  return <>{children}</>;
};

export default ProtectedRoute;
