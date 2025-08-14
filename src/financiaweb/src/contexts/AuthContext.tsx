import React, { createContext, useContext, useState, useEffect } from 'react';
import type { ReactNode } from 'react';
import UserServices from '../services/UserServices';

interface User {
  id: string;
  email: string;
  name: string;
}



interface AuthContextType {
  user: User | null;
  token: string | null;
  login: (email: string, password: string) => Promise<boolean>;
  signup: (fullName: string, email: string, password: string, passwordConfirmation: string) => Promise<boolean>; // <-- Agregado
  logout: () => void;
  isAuthenticated: boolean;
  isLoading: boolean;
  photoPreviewContext: string;
  setPhotoPreviewContext: React.Dispatch<React.SetStateAction<string>>;

}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

interface AuthProviderProps {
  children: ReactNode;
}

export const AuthProvider: React.FC<AuthProviderProps> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [token, setToken] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [photoPreviewContext,setPhotoPreviewContext]=useState<string>("")

  // Inicializar desde localStorage cuando la app carga
  useEffect(() => {
    const storedToken = localStorage.getItem('accessToken');
    const storedUser = localStorage.getItem('user');
    
    if (storedToken && storedUser) {
      setToken(storedToken);
      setUser(JSON.parse(storedUser));
    }
    setIsLoading(false);
  }, []);

  // Función para decodificar JWT y extraer información del usuario
  const decodeToken = (token: string): User | null => {
    try {
      const payload = JSON.parse(atob(token.split('.')[1]));
      return {
        id: payload.sub,
        email: payload.email,
        name: payload.name
      };
    } catch (error) {
      console.error('Error decoding token:', error);
      return null;
    }
  };

  const login = async (email: string, password: string): Promise<boolean> => {
    try {
      const response = await UserServices.loginUser({ email, password });
      
      if (response.status === 200 && response.data) {
        const { accessToken, refreshToken } = response.data.data || response.data;
        
        // Decodificar token para obtener información del usuario
        const userData = decodeToken(accessToken);
        
        if (userData) {
          // Guardar en estado
          setToken(accessToken);
          setUser(userData);
          
          // Guardar en localStorage
          localStorage.setItem('accessToken', accessToken);
          localStorage.setItem('refreshToken', refreshToken);
          localStorage.setItem('user', JSON.stringify(userData));
          
          return true;
        }
      }
      return false;
    } catch (error) {
      console.error('Login error:', error);
      return false;
    }
  };

  const signup = async (
    fullName: string,
    email: string,
    password: string,
    passwordConfirmation: string
  ): Promise<boolean> => {
    try {
      const response = await UserServices.registerUser({
        fullName,
        email,
        password,
        passwordConfirmation,
      });
      // Puedes ajustar la lógica según la respuesta de tu backend
      return response.status === 201 || response.status === 200;
    } catch (error) {
      console.error('Signup error:', error);
      return false;
    }
  };

  const logout = () => {
    setUser(null);
    setToken(null);
    localStorage.removeItem('accessToken');
    localStorage.removeItem('refreshToken');
    localStorage.removeItem('user');
  };

  const value: AuthContextType = {
    user,
    token,
    login,
    signup, // <-- Agregado aquí
    logout,
    isAuthenticated: !!token && !!user,
    isLoading,
    setPhotoPreviewContext,
    photoPreviewContext
    
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = (): AuthContextType => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

// Código del componente donde se usará el signup
// const MyComponent = () => {
//   const { signup } = useAuth();

//   const handleSignup = async () => {
//     const fullName = 'John Doe';
//     const email = 'john.doe@example.com';
//     const password = 'password123';
//     const passwordConfirmation = 'password123';

//     const result = await signup(fullName, email, password, passwordConfirmation);
//     if (result) {
//       console.log('Signup successful!');
//     } else {
//       console.log('Signup failed.');
//     }
//   };

//   return (
//     <div>
//       <h1>Signup</h1>
//       <button onClick={handleSignup}>Sign up</button>
//     </div>
//   );
// };
