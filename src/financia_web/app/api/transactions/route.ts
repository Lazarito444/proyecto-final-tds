import { NextRequest, NextResponse } from 'next/server';
import { cookies } from 'next/headers';

const API_URL = process.env.NEXT_PUBLIC_API_URL as string;

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    console.log('💰 API Route - Create transaction request:', body);

    // ✅ Validar datos requeridos
    const { categoryId, description, amount, dateTime, isEarning } = body;
    
    if (!categoryId || !description || amount === undefined || !dateTime || isEarning === undefined) {
      return NextResponse.json(
        { success: false, error: 'Faltan datos requeridos' },
        { status: 400 }
      );
    }

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
    const response = await fetch(`${API_URL}/transaction`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${accessToken}`
      },
      body: JSON.stringify({
        categoryId,
        description,
        amount: parseFloat(amount),
        dateTime,
        isEarning: Boolean(isEarning)
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
        { success: false, error: 'Error al crear transacción' },
        { status: response.status }
      );
    }

    const data = await response.json();
    console.log('✅ Transaction created:', data);

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

export async function GET(request: NextRequest) {
  try {
    console.log('💰 API Route - Get transactions request');

    // ✅ Obtener parámetros de query
    const { searchParams } = new URL(request.url);
    const startDate = searchParams.get('startDate');
    const endDate = searchParams.get('endDate');

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

    // ✅ Construir URL con parámetros
    let backendUrl = `${API_URL}/transaction`;
    if (startDate && endDate) {
      backendUrl += `?startDate=${startDate}&endDate=${endDate}`;
    }

    // ✅ Hacer request al backend con token
    const response = await fetch(backendUrl, {
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
        { success: false, error: 'Error al obtener transacciones' },
        { status: response.status }
      );
    }

    const data = await response.json();
    console.log('✅ Transactions fetched:', data);

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
