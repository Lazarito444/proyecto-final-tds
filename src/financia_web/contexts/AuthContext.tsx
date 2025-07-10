'use client'
import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { useRouter } from 'next/navigation';

interface User {
  id: string;
  email: string;
  name: string;
}

interface AuthContextType {
  user: User | null;
  isLoading: boolean;
  isAuthenticated: boolean;
  login: (email: string, password: string) => Promise<{ success: boolean; error?: string }>;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

interface AuthProviderProps {
  children: ReactNode;
}

export const AuthProvider: React.FC<AuthProviderProps> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const router = useRouter();

  const isAuthenticated = !!user;

  // ✅ Verificar cookies del usuario al cargar
  useEffect(() => {
    checkAuthStatus();
  }, []);

  const checkAuthStatus = () => {
    setIsLoading(true);
    
    // ✅ Leer cookie del usuario (accesible desde cliente)
    const userCookie = document.cookie
      .split('; ')
      .find(row => row.startsWith('user='))
      ?.split('=')[1];
    
    if (userCookie) {
      try {
        const userData = JSON.parse(decodeURIComponent(userCookie));
        setUser(userData);
      } catch (error) {
        console.error('Error parsing user cookie:', error);
        setUser(null);
      }
    } else {
      setUser(null);
    }
    
    setIsLoading(false);
  };

  const login = async (email: string, password: string): Promise<{ success: boolean; error?: string }> => {
    try {
      console.log('🔐 AuthContext - Iniciando login...');
      
      const response = await fetch('/api/auth/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, password }),
      });

      const data = await response.json();
      console.log('📡 Login response:', data);
      
      if (data.success && data.user) {
        setUser(data.user);
        return { success: true };
      } else {
        return { success: false, error: data.error || 'Error desconocido' };
      }
    } catch (error) {
      console.error('❌ Error en login:', error);
      return { success: false, error: 'Error de conexión' };
    }
  };

  const logout = async () => {
    try {
      console.log('🚪 AuthContext - Iniciando logout...');
      
      await fetch('/api/auth/logout', {
        method: 'POST',
      });
      
      setUser(null);
      router.push('/Login');
    } catch (error) {
      console.error('❌ Error en logout:', error);
      // Limpiar estado local aunque falle el servidor
      setUser(null);
      router.push('/Login');
    }
  };

  const value: AuthContextType = {
    user,
    isLoading,
    isAuthenticated,
    login,
    logout,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};
