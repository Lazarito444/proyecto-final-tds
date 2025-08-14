import type { AxiosResponse } from "axios";
import api from "../utils/axiosConfig";

class DashboardServices {
    static async getData(): Promise<AxiosResponse> {
        try {
            const response = await api.get('/api/dashboard-data');
            return response;
        } catch (error) {
            throw error;
        }
    }


}

export default DashboardServices;