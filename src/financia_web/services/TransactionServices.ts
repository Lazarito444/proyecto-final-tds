// TransactionServices - Manejo de transacciones mediante API Routes
interface TransactionData {
  categoryId: string;
  description: string;
  amount: number;
  dateTime: string;
  isEarning: boolean;
}

interface Transaction extends TransactionData {
  id: string;
  userId: string;
  name: string;
}

class TransactionServices {
    static async createTransaction(transactionData: TransactionData): Promise<any> {
        try {
            console.log('💰 TransactionServices - Creating transaction:', transactionData);
            
            const response = await fetch('/api/transactions', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(transactionData)
            });

            const data = await response.json();
            console.log('📡 Transaction response:', data);

            if (!data.success) {
                throw new Error(data.error || 'Error al crear transacción');
            }

            return data.data;
        } catch (error) {
            console.error('❌ Error creating transaction:', error);
            throw error;
        }
    }

    static async getTransactions(): Promise<Transaction[]> {
        try {
            console.log('💰 TransactionServices - Getting transactions');
            
            const response = await fetch('/api/transactions', {
                method: 'GET'
            });

            const data = await response.json();
            console.log('📡 Transactions response:', data);

            if (!data.success) {
                throw new Error(data.error || 'Error al obtener transacciones');
            }

            return data.data;
        } catch (error) {
            console.error('❌ Error getting transactions:', error);
            throw error;
        }
    }

    static async updateTransaction(id: string, transactionData: Partial<TransactionData>): Promise<any> {
        try {
            console.log('💰 TransactionServices - Updating transaction:', id, transactionData);
            
            const response = await fetch(`/api/transactions/${id}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(transactionData)
            });

            const data = await response.json();
            console.log('📡 Update transaction response:', data);

            if (!data.success) {
                throw new Error(data.error || 'Error al actualizar transacción');
            }

            return data.data;
        } catch (error) {
            console.error('❌ Error updating transaction:', error);
            throw error;
        }
    }

    static async deleteTransaction(id: string): Promise<boolean> {
        try {
            console.log('💰 TransactionServices - Deleting transaction:', id);
            
            const response = await fetch(`/api/transactions/${id}`, {
                method: 'DELETE'
            });

            const data = await response.json();
            console.log('📡 Delete transaction response:', data);

            if (!data.success) {
                throw new Error(data.error || 'Error al eliminar transacción');
            }

            return true;
        } catch (error) {
            console.error('❌ Error deleting transaction:', error);
            throw error;
        }
    }

    static async getTransactionsByDateRange(startDate: string, endDate: string): Promise<Transaction[]> {
        try {
            console.log('💰 TransactionServices - Getting transactions by date range:', startDate, endDate);
            
            const response = await fetch(`/api/transactions?startDate=${startDate}&endDate=${endDate}`, {
                method: 'GET'
            });

            const data = await response.json();
            console.log('📡 Transactions by date response:', data);

            if (!data.success) {
                throw new Error(data.error || 'Error al obtener transacciones por fecha');
            }

            return data.data;
        } catch (error) {
            console.error('❌ Error getting transactions by date:', error);
            throw error;
        }
    }
}

export default TransactionServices;
export type { TransactionData, Transaction };
