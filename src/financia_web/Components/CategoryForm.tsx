"use client";
import React from 'react'
import TextField from '@mui/material/TextField';

type Props = {}

const CategoryForm = (props: Props) => {
    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault()
        const formData = new FormData(e.currentTarget);
        const data = {
            name: formData.get('name') as string,
            email: formData.get('email') as string,
            password: formData.get('password') as string,
            confirmPassword: formData.get('confirmPassword') as string
        }   
        console.log(data);
    }
  return (
<form onSubmit={handleSubmit} className='flex flex-col items-center justify-center gap-y-4'>
      <TextField id="standard-basic" label="Nombre completo" variant="standard" name="name" className=' boder-b-[rgb(31,133,119)]' />
      <TextField id="standard-basic" label="Correo electrónico" variant="standard" type='email' name="email" />
      <TextField id="standard-basic" label="Contraseña" variant="standard" name="password" />
      <TextField id="standard-basic" label="Confirmar contraseña" variant="standard" name="confirmPassword" />
     <button className="bg-[rgb(31,133,119)] w-[200px] h-[50px] text-xl rounded-lg text-white font-medium cursor-pointer hover:opacity-80">Crear</button>


</form>
  )
}

export default CategoryForm