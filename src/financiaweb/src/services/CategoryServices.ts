// CategoryServices - Manejo de categorías mediante API Routes usando axios configurado
import type { AxiosResponse } from "axios";
import api from "../utils/axiosConfig";

class CategoryServices {
    static async createCategory(name: string): Promise<AxiosResponse> {
        try {
            const response = await api.post('/api/category', {
                name
            });
            return response;
        } catch (error) {
            throw error;
        }
    }

    static async getCategories(): Promise<AxiosResponse> {
        try {
            const response = await api.get('/api/category');
            return response;
        } catch (error) {
            throw error;
        }
    }

    static async updateCategory(id: number, name: string): Promise<AxiosResponse> {
        try {
            const response = await api.put(`/api/category/${id}`, {
                name
            });
            return response;
        } catch (error) {
            throw error;
        }
    }

    static async deleteCategory(id: number): Promise<AxiosResponse> {
        try {
            const response = await api.delete(`/api/category/${id}`);
            return response;
        } catch (error) {
            throw error;
        }
    }
}

export default CategoryServices;