'use client'
import React from 'react'
import TextField from '@mui/material/TextField';
import { IoMdArrowBack } from "react-icons/io";
import UserServices from '../../services/UserServices';
import Swal from 'sweetalert2';
import { useRouter } from 'next/navigation';



const SignUp = () => {
    const router = useRouter();
    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault()
        const formData = new FormData(e.currentTarget);
        const data = {
          personName:"prueba1",
          email: formData.get('email') as string,
          phoneNumber:"515545",
            password: formData.get('password') as string,
            confirmPassword:formData.get('confirmPassword') as string
        }
         const response = await UserServices.registerUser(data)
        if(response.status === 200){
          Swal.fire({
            title: 'Usuario creado correctamente',
            text: 'El usuario ha sido creado correctamente',
            icon: 'success',
            confirmButtonText: 'Aceptar'
          })
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
  <h1 className="text-[#113931] text-3xl font-bold">Registro</h1>
</div>

<div className="flex flex-col items-center justify-center gap-y-2">
<form onSubmit={handleSubmit} className='flex flex-col items-center justify-center gap-y-4'>
      <TextField id="standard-basic" label="Nombre completo" variant="standard" name="name" className=' boder-b-[rgb(31,133,119)]' />
      <TextField id="standard-basic" label="Correo electrónico" variant="standard" type='email' name="email" />
      <TextField id="standard-basic" label="Contraseña" variant="standard" name="password" />
      <TextField id="standard-basic" label="Confirmar contraseña" variant="standard" name="confirmPassword" />
     <button className="bg-[rgb(31,133,119)] w-[200px] h-[50px] text-xl rounded-lg text-white font-medium cursor-pointer hover:opacity-80">Crear cuenta</button>
     <p>Al registrarse Acrorias nuestra</p>
        <p className="text-[rgb(31,133,119)] cursor-pointer">Política de privacidad</p>

</form>
</div>
</div>
      
    </div>
  )
}

export default SignUp