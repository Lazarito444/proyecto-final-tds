'use client'
import Link from 'next/link';
import Image from 'next/image';
const Index = () => {


  return (
    <>
    <div className=" bg-white w-[900px] h-[600px] flex flex-col items-center justify-center  rounded-lg shadow-lg p-6 mx-auto mt-[100px]">
<div className=" relative flex flex-col items-center justify-center mb-6">
      <Image src="/Logo.png" alt="logo" width={400} height={400} className="absolute bottom-20 left-0" />
  <div className="mb-20">
</div>

<div className="flex flex-col items-center justify-center gap-y-2">
 <Link href="/Login" className="bg-[rgb(31,133,119)] w-[200px] h-[50px] text-xl rounded-lg text-white font-medium cursor-pointer hover:opacity-80  flex items-center justify-center">Iniciar Sesión</Link>
 <button><Link href="/Signup" className="w-[200px] h-[50px] text-xl rounded-lg text-[#113931] font-medium border border-green-200 cursor-pointer hover:bg-[rgb(31,133,119)] flex items-center justify-center hover:text-white transition-all ease-in-out delay-[0.6s]">Registrarse</Link></button>
</div>
</div>
      
    </div>
    </>
  )
}

export default Index


//bg-[#E8F5F2]