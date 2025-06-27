import Piechart from '../../Components/Piechart';
import Header from '../../Components/Header';
import { formatNumber } from '../../utils/functions';
import { FaMoneyBillWave } from 'react-icons/fa';
import Cards from '../../Components/Cards';

const Dashboard = () => {
  return (
    <>
      <Header />
      <div className="relative bg-white w-[95%] h-[600] flex flex-col items-center justify-center p-4 rounded-lg shadow-lg mx-auto mt-10">      
        <h1 className='text-2xl font-bold'>Saldo Actual</h1>
        <p className='text-2xl font-bold'>{formatNumber(1000)}</p>
        <div className='flex items-center justify-center gap-x-4 mt-4'>
          <Cards title='Gastos' value={formatNumber(1000)} icon={<FaMoneyBillWave />} />
          <Cards title='Ingresos' value={formatNumber(1000)} icon={<FaMoneyBillWave />} />
        </div>
        
        <Piechart />
      </div>
    </>
  )
}

export default Dashboard