import { NextResponse } from 'next/server';
import { cookies } from 'next/headers';

export async function POST() {
  try {
    console.log('🚪 Logout - Limpiando cookies...');
    
    const cookieStore = await cookies();
    
    // Limpiar todas las cookies de autenticación
    cookieStore.delete('accessToken');
    cookieStore.delete('refreshToken');
    cookieStore.delete('user');

    console.log('✅ Logout exitoso');

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error('❌ Error en logout:', error);
    return NextResponse.json(
      { success: false, error: 'Error al cerrar sesión' },
      { status: 500 }
    );
  }
}
