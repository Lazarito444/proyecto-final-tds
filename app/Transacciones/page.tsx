import React from 'react'
import Header from '../../Components/Header'
import Tabs from '../../Components/Tabs'
type Props = {}

const Transacciones = (props: Props) => {
  return (
    <>
    <Header />
    <div className='bg-white w-[95%] h-[600px] flex flex-col items-center    rounded-lg shadow-lg mx-auto mt-[100px] md:mt-010'>
     <div className='flex flex-col items-center justify-center mt-10'>
     <h1 className='text-2xl font-bold'>Transacciones</h1>
        <div className='flex items-center justify-center gap-x-4 mt-4'>
           <Tabs />
        </div>
     </div>
    </div>
    </>
  )
}

export default Transacciones