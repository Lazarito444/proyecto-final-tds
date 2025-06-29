import axios, { type AxiosResponse } from "axios";
import type { LoginUser, RegisterUser } from "../Interfaces/UserInterface";

const API_URL = process.env.NEXT_PUBLIC_API_URL as string;

class UserServices {
  static async registerUser(
    user: RegisterUser
  ): Promise<AxiosResponse<AxiosResponse>> {
    try {
      const response = await axios.post(`${API_URL}/Account/register`, {
        email: user.email,
        password: user.password,
        personName: user.personName,
        phoneNumber: user.phoneNumber,
        confirmPassword: user.confirmPassword
          
      }, {
        headers: {
          'Content-Type': 'application/json',
        },
  
      });
      return response;
  
    
    } catch (error) {
      throw error;
      
    }
  }

  static async loginUser(
    user: LoginUser
  ): Promise<AxiosResponse<AxiosResponse>> {
    try {
      const response = await axios.post(`${API_URL}/Account/login`, {
        email: user.email,
        password: user.password
      }, {
        headers: {
          'Content-Type': 'application/json',
        },
      });
      return response;
    } catch (error) {   
      throw error;
    }
  }
  static async logoutUser(): Promise<AxiosResponse<AxiosResponse>> {
    try {
      const response = await axios.get(`${API_URL}/Account/Logout`);
      return response;
    } catch (error) {
      throw error;
    }
  }
}
export default UserServices;