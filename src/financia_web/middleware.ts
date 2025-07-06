import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

// ✅ Rutas que requieren autenticación
const protectedRoutes = ['/Dashboard', '/Transacciones', '/categorias', '/presupuesto', '/alertas', '/sugerencias']

// ✅ Rutas que NO deben ser accesibles si ya está logueado
const authRoutes = ['/Login', '/Signup']

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl
  
  // Obtener cookies
  const accessToken = request.cookies.get('accessToken')?.value
  const user = request.cookies.get('user')?.value
  
  const isAuthenticated = !!(accessToken && user)
  
  // ✅ Si está en ruta protegida sin estar autenticado
  if (protectedRoutes.some(route => pathname.startsWith(route)) && !isAuthenticated) {
    const loginUrl = new URL('/Login', request.url)
    return NextResponse.redirect(loginUrl)
  }
  
  // ✅ Si está autenticado e intenta acceder a login/signup
  if (authRoutes.some(route => pathname.startsWith(route)) && isAuthenticated) {
    const dashboardUrl = new URL('/Dashboard', request.url)
    return NextResponse.redirect(dashboardUrl)
  }
  
  return NextResponse.next()
}

// ✅ Configurar en qué rutas ejecutar el middleware
export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - api (API routes)
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     * - public folder
     */
    '/((?!api|_next/static|_next/image|favicon.ico|public).*)',
  ],
}
