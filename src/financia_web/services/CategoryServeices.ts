class CategoryServices{
    static async getCategories() {
        try {
            const response = await fetch('/api/categories');
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            const data = await response.json();
            return data;
        } catch (error) {
            console.error('Error fetching categories:', error);
            throw error;
        }
    }
}
export default new CategoryServices