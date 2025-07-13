// CategoryServices - Manejo de categorías mediante API Routes usando fetch
class CategoryServices {
    static async createCategory(name: string): Promise<any> {
        try {
            console.log('📋 CategoryServices - Creating category:', name);
            
            const response = await fetch('/api/categories', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ name })
            });

            const data = await response.json();
            console.log('📡 Category response:', data);

            if (!data.success) {
                throw new Error(data.error || 'Error al crear categoría');
            }

            return data.data;
        } catch (error) {
            console.error('❌ Error creating category:', error);
            throw error;
        }
    }

    static async getCategories(): Promise<any> {
        try {
            console.log('📋 CategoryServices - Getting categories');
            
            const response = await fetch('/api/categories', {
                method: 'GET'
            });

            const data = await response.json();
            console.log('📡 Categories response:', data);

            if (!data.success) {
                throw new Error(data.error || 'Error al obtener categorías');
            }

            return data.data;
        } catch (error) {
            console.error('❌ Error getting categories:', error);
            throw error;
        }
    }
}
export default  CategoryServices