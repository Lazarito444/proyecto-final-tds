import { getAccessToken } from '../app/actions/auth';

const API_URL = process.env.NEXT_PUBLIC_API_URL as string;

class ApiService {
  // ✅ Hacer request autenticado desde el servidor
  static async authenticatedFetch(endpoint: string, options: RequestInit = {}) {
    const token = await getAccessToken();
    
    return fetch(`${API_URL}${endpoint}`, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...(token && { Authorization: `Bearer ${token}` }),
        ...options.headers,
      },
    });
  }
  
  // ✅ Hacer request autenticado desde el cliente
  static async clientAuthenticatedFetch(endpoint: string, options: RequestInit = {}) {
    return fetch(`${API_URL}${endpoint}`, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
      credentials: 'include', // Envía cookies automáticamente
    });
  }
}

export default ApiService;
