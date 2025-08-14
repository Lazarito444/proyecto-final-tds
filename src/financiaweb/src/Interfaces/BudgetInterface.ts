export interface Budget {
  id: string;
  categoryId: string;
  startDate: string;
  endDate: string;
  isRecurring: boolean;
  maximumAmount: number;
}
