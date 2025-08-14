import api from "../utils/axiosConfig";
import type { AxiosResponse } from "axios";

class AIServices {
  static async getSuggestions(): Promise<AxiosResponse> {
    return api.get('/api/ai/suggestions');
  }

  static async getPredictions(): Promise<AxiosResponse> {
    return api.get('/api/ai/predictions');
  }

  static async sendChatMessage(prompt: string): Promise<AxiosResponse> {
    return api.post('/api/ai/chatbot', { prompt });
  }
}

export default AIServices;