import axios from 'axios';


const BASE_URL = import.meta.env.VITE_API_URL; // Cambia por tu URL base

// Crear una instancia de axios
const api = axios.create({
  baseURL: BASE_URL,
});

// Interceptor para requests - agregar token automáticamente
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('accessToken');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Interceptor para responses - manejar errores 401
api.interceptors.response.use(
  (response) => {
    return response;
  },
  async (error) => {
    const originalRequest = error.config;

    if (error.response?.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;

      try {
        const refreshToken = localStorage.getItem('refreshToken');
        if (refreshToken) {
          // Intentar refrescar el token
          const response = await axios.post(`${BASE_URL}/api/auth/refresh`, {
            refreshToken: refreshToken
          });

          if (response.data?.accessToken) {
            const newToken = response.data.accessToken;
            localStorage.setItem('accessToken', newToken);
            
            // Reintentar la petición original con el nuevo token
            originalRequest.headers.Authorization = `Bearer ${newToken}`;
            return api(originalRequest);
          }
        }
      } catch (refreshError) {
        // Si el refresh falla, limpiar tokens y redirigir al login
        localStorage.removeItem('accessToken');
        localStorage.removeItem('refreshToken');
        localStorage.removeItem('user');
        window.location.href = '/login';
        return Promise.reject(refreshError);
      }
    }

    return Promise.reject(error);
  }
);

export default api;
