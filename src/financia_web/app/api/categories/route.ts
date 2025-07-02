import { NextRequest, NextResponse } from 'next/server';
import { cookies } from 'next/headers';

const API_URL = process.env.NEXT_PUBLIC_API_URL as string;

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    console.log('📋 API Route - Create category request:', body);

    // ✅ Obtener token desde cookies httpOnly
    const cookieStore = await cookies();
    const accessToken = cookieStore.get('accessToken')?.value;

    if (!accessToken) {
      console.error('❌ No access token found');
      return NextResponse.json(
        { success: false, error: 'No autorizado' },
        { status: 401 }
      );
    }

    // ✅ Hacer request al backend con token
    const response = await fetch(`${API_URL}/category`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${accessToken}`
      },
      body: JSON.stringify({
        name: body.name
      }),
    });

    console.log('📡 Backend response status:', response.status);

    if (!response.ok) {
      const errorText = await response.text();
      console.error('❌ Backend error:', errorText);
      
      if (response.status === 401) {
        return NextResponse.json(
          { success: false, error: 'Token expirado' },
          { status: 401 }
        );
      }
      
      return NextResponse.json(
        { success: false, error: 'Error al crear categoría' },
        { status: response.status }
      );
    }

    const data = await response.json();
    console.log('✅ Category created:', data);

    return NextResponse.json({
      success: true,
      data
    });

  } catch (error) {
    console.error('❌ API Route error:', error);
    return NextResponse.json(
      { success: false, error: 'Error interno del servidor' },
      { status: 500 }
    );
  }
}

export async function GET() {
  try {
    console.log('📋 API Route - Get categories request');

    // ✅ Obtener token desde cookies httpOnly
    const cookieStore = await cookies();
    const accessToken = cookieStore.get('accessToken')?.value;

    if (!accessToken) {
      console.error('❌ No access token found');
      return NextResponse.json(
        { success: false, error: 'No autorizado' },
        { status: 401 }
      );
    }

    // ✅ Hacer request al backend con token
    const response = await fetch(`${API_URL}/category`, {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${accessToken}`
      },
    });

    console.log('📡 Backend response status:', response.status);

    if (!response.ok) {
      const errorText = await response.text();
      console.error('❌ Backend error:', errorText);
      
      if (response.status === 401) {
        return NextResponse.json(
          { success: false, error: 'Token expirado' },
          { status: 401 }
        );
      }
      
      return NextResponse.json(
        { success: false, error: 'Error al obtener categorías' },
        { status: response.status }
      );
    }

    const data = await response.json();
    console.log('✅ Categories fetched:', data);

    return NextResponse.json({
      success: true,
      data
    });

  } catch (error) {
    console.error('❌ API Route error:', error);
    return NextResponse.json(
      { success: false, error: 'Error interno del servidor' },
      { status: 500 }
    );
  }
}
