import api from "../utils/axiosConfig";
import type { AxiosResponse } from "axios";

export interface AccountData {
  fullName: string;
  dateOfBirth: string;
  gender: number;
  password?: string;
  currentPassword?: string;
  photoFile?: File | null;
}

class UserAccountServices {
  static async getAccount(id: string): Promise<AxiosResponse> {
    return api.get(`/api/account/${id}`);
  }

  static async updateAccount(id: string, data: AccountData): Promise<AxiosResponse> {
    const formData = new FormData();
    formData.append("FullName", data.fullName);
    formData.append("DateOfBirth", data.dateOfBirth);
    formData.append("Gender", String(data.gender));
    if (data.password) formData.append("Password", data.password);
    if (data.currentPassword) formData.append("CurrentPassword", data.currentPassword);
    if (data.photoFile) formData.append("PhotoFile", data.photoFile);

    return api.put(`/api/account/${id}`, formData, {
      headers: { "Content-Type": "multipart/form-data" }
    });
  }
}

export default UserAccountServices;