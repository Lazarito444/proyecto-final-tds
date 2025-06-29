'use client'
import React from 'react'
import TextField from '@mui/material/TextField';
import { IoMdArrowBack } from "react-icons/io";
import { useRouter } from 'next/navigation';
import Image from 'next/image';
import UserServices from '../../services/UserServices';


type Props = {}

const Login = (props: Props) => {
    const router = useRouter();
    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault()
        const formData = new FormData(e.currentTarget);
        const data = {
            email: formData.get('email') as string,
            password: formData.get('password') as string
        }
      const response = await UserServices.loginUser(data)
      if(response.status === 200){
        router.push('/Dashboard')
      }
    }
    const goToIndex = () => {
        router.push('/')
    }

  return (
     <div className="relative bg-white w-[900px] h-[600px] flex flex-col items-center justify-center  rounded-lg shadow-lg p-6 mx-auto mt-[100px]">
    <IoMdArrowBack className=" absolute left-20 top-6 text-[#113931] w-[30px] h-[30px] cursor-pointer" onClick={goToIndex} />
<div className="flex flex-col items-center justify-center mb-6">
  <div className="mb-10">
  <h1 className="text-[#113931] text-3xl font-bold">Login</h1>
</div>

<div className="flex flex-col items-center justify-center gap-y-2">
<form onSubmit={handleSubmit} className='flex flex-col items-center justify-center gap-y-4'>
      <TextField id="standard-basic" label="Correo electrónico" variant="standard" type="email" name="email" />
      <TextField id="standard-basic" label="Contraseña" variant="standard" type="password" name="password" />
     <button className="bg-[rgb(31,133,119)] w-[200px] h-[50px] text-xl rounded-lg text-white font-medium cursor-pointer hover:opacity-80">Crear cuenta</button>
        <p>
            No tienes una cuenta? <span className="text-[rgb(31,133,119)] cursor-pointer" onClick={() => router.push('/signup')}>Registrate</span>
        </p>
</form>
</div>
</div>
      
    </div>
  )
}

export default Login