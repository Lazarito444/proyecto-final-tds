import { NextRequest, NextResponse } from 'next/server';
import { cookies } from 'next/headers';

const API_URL = process.env.NEXT_PUBLIC_API_URL as string;

interface RouteParams {
  params: {
    id: string;
  };
}

export async function PUT(request: NextRequest, { params }: RouteParams) {
  try {
    const { id } = params;
    const body = await request.json();
    console.log('💰 API Route - Update transaction request:', id, body);

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
    const response = await fetch(`${API_URL}/transaction/${id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${accessToken}`
      },
      body: JSON.stringify(body),
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
        { success: false, error: 'Error al actualizar transacción' },
        { status: response.status }
      );
    }

    const data = await response.json();
    console.log('✅ Transaction updated:', data);

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

export async function DELETE(request: NextRequest, { params }: RouteParams) {
  try {
    const { id } = params;
    console.log('💰 API Route - Delete transaction request:', id);

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
    const response = await fetch(`${API_URL}/transaction/${id}`, {
      method: 'DELETE',
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
        { success: false, error: 'Error al eliminar transacción' },
        { status: response.status }
      );
    }

    console.log('✅ Transaction deleted');

    return NextResponse.json({
      success: true,
      message: 'Transacción eliminada exitosamente'
    });

  } catch (error) {
    console.error('❌ API Route error:', error);
    return NextResponse.json(
      { success: false, error: 'Error interno del servidor' },
      { status: 500 }
    );
  }
}

export async function GET(request: NextRequest, { params }: RouteParams) {
  try {
    const { id } = params;
    console.log('💰 API Route - Get transaction by id request:', id);

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
    const response = await fetch(`${API_URL}/transaction/${id}`, {
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
        { success: false, error: 'Error al obtener transacción' },
        { status: response.status }
      );
    }

    const data = await response.json();
    console.log('✅ Transaction fetched:', data);

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
