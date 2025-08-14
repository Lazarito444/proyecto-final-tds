import { lazy, useEffect, useState } from 'react';
import TransactionServices from '../services/TransactionServices';
import type { Transaction } from '../Interfaces/TransactionsInterface';

const PieChart = lazy(() => import('@mui/x-charts').then((mod) => ({ default: mod.PieChart })));


export default function BasicPie() {
  const [gastos, setGastos] = useState<Transaction[]>([]);
  const [ingresos, setIngresos] = useState<Transaction[]>([]);
  const getData = async () => {
    try {
      const response = await TransactionServices.getTransactions()

      const getGastos = response.data.filter((gasto: any) => !gasto.isEarning)
      const getIngresos = response.data.filter((ingreso: any) => ingreso.isEarning)
      setIngresos(getIngresos)
      setGastos(getGastos)
    } catch (error) {
      console.error('Error fetching data:', error);
      setGastos([]);
      setIngresos([]);
    }
  }
useEffect(() => {
  getData();
  return () => {
    setGastos([]);
    setIngresos([]);
  }
},[]);
  return (
    <div >
      <PieChart
        series={[
          {
            data: [
              { id: 0, value: gastos.reduce((acc, gasto) => acc + gasto.amount, 0), label: 'Gastos' },
              { id: 1, value: ingresos.reduce((acc, ingreso) => acc + ingreso.amount, 0), label: 'Ingresos' },
            ],
          },
        ]}
        width={200}
        height={200}
      />
    </div>
  );
}