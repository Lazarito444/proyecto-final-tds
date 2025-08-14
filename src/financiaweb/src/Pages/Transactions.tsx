import Header from '../Components/Header'
import Tabs from '../Components/Tabs'

const Transacciones = () => {
  return (
    <>
    <Header />
    <div className='bg-white w-[95%] h-[600px] flex flex-col items-center rounded-lg shadow-lg mx-auto mt-[100px] md:mt-10 p-4 overflow-auto'>
     <div className='w-full'>
       <h1 className='text-2xl font-bold text-center mb-4'>Transacciones</h1>
       <div className='w-full'>
         <Tabs />
       </div>
     </div>
    </div>
    </>
  )
}

export default Transacciones