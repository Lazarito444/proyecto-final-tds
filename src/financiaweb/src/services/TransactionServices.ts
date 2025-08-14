// TransactionServices - Manejo de transacciones mediante API Routes
import type { AxiosResponse } from "axios";
import api from "../utils/axiosConfig";

interface TransactionData {
  categoryId: string;
  description: string;
  amount: number;
  dateTime: string;
  isEarning: boolean;
}


class TransactionServices {
    static async createTransaction(transactionData: TransactionData): Promise<AxiosResponse> {
        try {

            const formData = new FormData();
            formData.append('categoryId', transactionData.categoryId);
            formData.append('description', transactionData.description);
            formData.append('amount', transactionData.amount.toString());
            formData.append('dateTime', transactionData.dateTime);
            formData.append('isEarning', transactionData.isEarning ? 'true' : 'false');

            const response = await api.post('/api/transaction', formData, {
                headers: {
                    "Content-Type": "multipart/form-data"
                }
            });
            return response;
        } catch (error) {
            console.error('❌ Error creating transaction:', error);
            throw error;
        }
    }

    static async getTransactions(): Promise<AxiosResponse> {
        try {
            const response = await api.get('/api/transaction');
            return response;
        } catch (error) {
            console.error('❌ Error getting transactions:', error);
            throw error;
        }
    }

    static async updateTransaction(id: string, formData:any): Promise<AxiosResponse> {
        try {
            const response = await api.put(`/api/transaction/${id}`,formData);
            return response;
        } catch (error) {
            console.error('❌ Error updating transaction:', error);
            throw error;
        }
    }

    static async deleteTransaction(id: string): Promise<AxiosResponse> {
        try {
            const response = await api.delete(`/api/transactions/${id}`);
            return response;
        } catch (error) {
            console.error('❌ Error deleting transaction:', error);
            throw error;
        }
    }

    static async getMonthlySummary(month: string): Promise<AxiosResponse> {

        try {
            const response = await api.get(`/api/transaction/monthly-summary?month=${month}`);
            return response;
        } catch (error) {
            console.error('❌ Error getting monthly summary:', error);
            throw error;
        }
    }

    static async filterTransactions(params: {
        categoryId?: string;
        isEarning?: boolean;
        fromDate?: string;
        toDate?: string;
    }): Promise<AxiosResponse> {
        try {
            const query = new URLSearchParams();
            if (params.categoryId) query.append('CategoryId', params.categoryId);
            if (params.isEarning !== undefined) query.append('Earning', String(params.isEarning));
            if (params.fromDate) query.append('FromDate', params.fromDate);
            if (params.toDate) query.append('ToDate', params.toDate);

            const response = await api.get(`/api/transaction/filter?${query.toString()}`);
            return response;
        } catch (error) {
            console.error('❌ Error filtering transactions:', error);
            throw error;
        }
    }
}
export default TransactionServices;

