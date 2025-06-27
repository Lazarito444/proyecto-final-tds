

import UserServices from '@/services/UserServices';

export async function logoutAction() {
    try {
        const response = await UserServices.logoutUser();
        return response.status === 204;
    } catch (error) {
        console.error('Error en logout action:', error);
        return false;
    }
} 