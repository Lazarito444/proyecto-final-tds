import Piechart from '../Components/Piechart';
import Header from '../Components/Header';
import { formatNumber } from '../utils/functions';
import { FaMoneyBillWave } from 'react-icons/fa';
import Cards from '../Components/Cards';
import { Suspense,useEffect,useState } from 'react';
import PieChartSkeleton from '../Skeleton/PiechartSkeleton';
import TransactionServices from '../services/TransactionServices';
import type { Transaction } from '../Interfaces/TransactionsInterface';
import DashboardServices from '../services/DashboardService';

interface DashboardTransaction {
  id: string;
  amount: number;
  description: string;
  categoryName: string;
  dateTime: string;
  isEarningCategory: boolean;
  colorHex: string;
  iconName: string;
}

interface DashboardData {
  userLastTransactions: DashboardTransaction[];
  earnings: number;
  expenses: number;
  earningsByCategory: any[];
  expensesByCategory: any[];
}
const Dashboard = () => {
    const [gastos, setGastos] = useState<Transaction[]>([]);
  const [ingresos, setIngresos] = useState<Transaction[]>([]);
  const [lastTransactions, setLastTransactions] = useState<DashboardTransaction[]>([]);
  const [dashboardStats, setDashboardStats] = useState<{ earnings: number; expenses: number }>({ earnings: 0, expenses: 0 });
  
  const getData = async () => {
    try {
      const response = await TransactionServices.getTransactions()
      const data = await DashboardServices.getData();

      // Datos de las transacciones originales
      const getGastos = response.data.filter((gasto: any) => !gasto.isEarning)
      const getIngresos = response.data.filter((ingreso: any) => ingreso.isEarning)
      setIngresos(getIngresos)
      setGastos(getGastos)
      
      // Datos del dashboard (últimas 5 transacciones y estadísticas)
      if (data.data) {
        setLastTransactions(data.data.userLastTransactions || []);
        setDashboardStats({
          earnings: data.data.earnings || 0,
          expenses: data.data.expenses || 0
        });
      }
      
    } catch (error) {
      console.error('Error fetching data:', error);
      setGastos([]);
      setIngresos([]);
      setLastTransactions([]);
    }
  }
useEffect(() => {
  getData();
  return () => {
    setGastos([]);
    setIngresos([]);
    setLastTransactions([]);
  }
},[]);
  
  return (
    <>
      <Header />
      <div className="relative bg-white w-[95%] min-h-[600px] flex flex-col items-center justify-center p-4 rounded-lg shadow-lg mx-auto mt-[100px] md:mt-10">      
        <h1 className='text-2xl font-bold'>Saldo Actual</h1>
        <p className='text-2xl font-bold'>
          {formatNumber(
            ingresos.reduce((acc, ingreso) => acc + ingreso.amount, 0) -
            gastos.reduce((acc, gasto) => acc + gasto.amount, 0)
          )}
        </p>
        <div className='flex flex-col md:flex-row gap-y-4 md:gap-x-4 items-center justify-center gap-x-4 my-4'>
          <Cards title='Gastos' value={formatNumber(gastos.reduce((acc, gasto) => acc + gasto.amount, 0))} icon={<FaMoneyBillWave />} />
          <Cards title='Ingresos' value={formatNumber(ingresos.reduce((acc, ingreso) => acc + ingreso.amount, 0))} icon={<FaMoneyBillWave />} />
        </div>

        {/* Gráfico */}
        <Suspense fallback={<PieChartSkeleton />}>
          <Piechart />
        </Suspense>

        {/* Últimas Transacciones */}
        {lastTransactions.length > 0 && (
          <div className="w-full max-w-4xl mt-6">
            <h2 className="text-xl font-bold mb-4 text-center">Últimas Transacciones</h2>
            <div className="bg-gray-50 rounded-lg p-4">
              <div className="space-y-3">
                {lastTransactions.map((transaction) => (
                  <div 
                    key={transaction.id} 
                    className="flex items-center justify-between bg-white p-3 rounded-lg shadow-sm hover:shadow-md transition-shadow"
                  >
                    <div className="flex-1">
                      <div className="flex items-center gap-3">
                        <div className="flex-1">
                          <p className="font-medium text-gray-900">{transaction.description}</p>
                          <p className="text-sm text-gray-500">{transaction.categoryName}</p>
                        </div>
                      </div>
                    </div>
                    <div className="text-right">
                      <p className={`font-bold ${transaction.isEarningCategory ? 'text-green-600' : 'text-red-600'}`}>
                        {transaction.isEarningCategory ? '+' : '-'}{formatNumber(transaction.amount)}
                      </p>
                      <p className="text-sm text-gray-500">
                        {new Date(transaction.dateTime).toLocaleDateString('es-ES', {
                          day: '2-digit',
                          month: '2-digit',
                          year: 'numeric'
                        })}
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}
      </div>
    </>
  )
}

export default Dashboard