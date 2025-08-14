import api from "../utils/axiosConfig";
import type { AxiosResponse } from "axios";

export interface SavingData {
  name: string;
  targetAmount: number;
  currentAmount: number;
  targetDate: string;
}

class SavingServices {
  static async getSavings(): Promise<AxiosResponse> {
    return api.get('/api/saving');
  }

  static async getSavingById(id: string): Promise<AxiosResponse> {
    return api.get(`/api/saving/${id}`);
  }

  static async createSaving(data: SavingData): Promise<AxiosResponse> {
    return api.post('/api/saving', data);
  }

  static async updateSaving(id: string, data: Partial<SavingData>): Promise<AxiosResponse> {
    return api.put(`/api/saving/${id}`, data);
  }

  static async deleteSaving(id: string): Promise<AxiosResponse> {
    return api.delete(`/api/saving/${id}`);
  }

  static async getSavingProgress(id: string): Promise<AxiosResponse> {
    return api.get(`/api/saving/${id}/progress`);
  }

  static async getSavingTransactions(id: string): Promise<AxiosResponse> {
    return api.get(`/api/saving/${id}/transactions`);
  }

  static async depositToSaving(id: string, amount: number): Promise<AxiosResponse> {
    return api.post(`/api/saving/${id}/deposit`, { amount });
  }
}

export default SavingServices;