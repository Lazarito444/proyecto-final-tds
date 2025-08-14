import api from "../utils/axiosConfig";
const API_URL = '/api/bugdet';

export const getBudgets = async () =>await  api.get(API_URL);
export const getBudgetById = async (id: string) =>await api.get(`${API_URL}/${id}`);
export const createBudget = async (data: any) =>await api.post(API_URL, data);
export const updateBudget = async (id: string, data: any) =>await api.put(`${API_URL}/${id}`, data);
export const deleteBudget = async (id: string) =>await api.delete(`${API_URL}/${id}`);

const BudgetServices = {
  getBudgets,
  getBudgetById,
  createBudget,
  updateBudget,
  deleteBudget,
};

export default BudgetServices;
