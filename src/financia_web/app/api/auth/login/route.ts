import { NextRequest, NextResponse } from 'next/server';
import { cookies } from 'next/headers';

const API_URL = process.env.NEXT_PUBLIC_API_URL as string;

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    console.log('🔐 API Route - Login request:', { email: body.email });

    const response = await fetch(`${API_URL}/auth/authenticate`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        email: body.email,
        password: body.password
      }),
    });

    console.log('📡 Backend response status:', response.status);

    if (!response.ok) {
      const errorText = await response.text();
      console.error('❌ Backend error:', errorText);
      return NextResponse.json(
        { success: false, error: 'Credenciales incorrectas' },
        { status: 401 }
      );
    }

    const responseText = await response.text();
    console.log('📄 Backend response:', responseText);

    let data;
    try {
      data = JSON.parse(responseText);
    } catch (parseError) {
      console.error('❌ JSON parse error:', parseError);
      return NextResponse.json(
        { success: false, error: 'Error en respuesta del servidor' },
        { status: 500 }
      );
    }

    console.log('✅ Login exitoso:', data);

    // ✅ Configurar cookies
    const cookieStore = await cookies();
    
    // Access token
    cookieStore.set('accessToken', data.accessToken, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict',
      maxAge: 15 * 60, // 15 minutos
      path: '/'
    });
    
    // Refresh token (si existe)
    if (data.refreshToken) {
      cookieStore.set('refreshToken', data.refreshToken, {
        httpOnly: true,
        secure: process.env.NODE_ENV === 'production',
        sameSite: 'strict',
        maxAge: 7 * 24 * 60 * 60, // 7 días
        path: '/'
      });
    }
    
    // Usuario (accesible desde cliente)
    cookieStore.set('user', JSON.stringify(data.user || { email: body.email }), {
      httpOnly: false,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict',
      maxAge: 7 * 24 * 60 * 60,
      path: '/'
    });

    return NextResponse.json({
      success: true,
      user: data.user || { email: body.email }
    });

  } catch (error) {
    console.error('❌ API Route error:', error);
    return NextResponse.json(
      { success: false, error: 'Error interno del servidor' },
      { status: 500 }
    );
  }
}
