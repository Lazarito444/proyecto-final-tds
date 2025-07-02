import { NextResponse } from 'next/server';
import { cookies } from 'next/headers';

const API_URL = process.env.NEXT_PUBLIC_API_URL as string;

export async function POST() {
  try {
    console.log('🔄 API Route - Refresh token request');

    const cookieStore = await cookies();
    const refreshToken = cookieStore.get('refreshToken')?.value;

    if (!refreshToken) {
      console.error('❌ No refresh token found');
      return NextResponse.json(
        { success: false, error: 'No refresh token' },
        { status: 401 }
      );
    }

    const response = await fetch(`${API_URL}/auth/refresh`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${refreshToken}`
      },
    });

    console.log('📡 Backend refresh response status:', response.status);

    if (!response.ok) {
      // Token inválido, limpiar cookies
      cookieStore.delete('accessToken');
      cookieStore.delete('refreshToken');
      cookieStore.delete('user');
      
      return NextResponse.json(
        { success: false, error: 'Refresh token inválido' },
        { status: 401 }
      );
    }

    const data = await response.json();
    console.log('✅ Token refreshed successfully');

    // Actualizar access token
    cookieStore.set('accessToken', data.accessToken, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict',
      maxAge: 15 * 60, // 15 minutos
      path: '/'
    });

    // Actualizar usuario si viene en la respuesta
    if (data.user) {
      cookieStore.set('user', JSON.stringify(data.user), {
        httpOnly: false,
        secure: process.env.NODE_ENV === 'production',
        sameSite: 'strict',
        maxAge: 7 * 24 * 60 * 60,
        path: '/'
      });
    }

    return NextResponse.json({
      success: true,
      user: data.user
    });

  } catch (error) {
    console.error('❌ Refresh token error:', error);
    return NextResponse.json(
      { success: false, error: 'Error interno del servidor' },
      { status: 500 }
    );
  }
}
