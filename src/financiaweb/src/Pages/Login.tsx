'use client'
import React, { useState } from 'react'
import TextField from '@mui/material/TextField';
import { IoMdArrowBack } from "react-icons/io";
import { useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import CircularProgress from '@mui/material/CircularProgress';
import Alert from '@mui/material/Alert';

type Props = {}

const Login = (props: Props) => {
    const navigate = useNavigate();
    const location = useLocation();
    const { login } = useAuth();
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState<string>('');

    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault()
        setIsLoading(true);
        setError('');

        const formData = new FormData(e.currentTarget);
        const email = formData.get('email') as string;
        const password = formData.get('password') as string;

        try {
            const success = await login(email, password);
            
            if (success) {
                // Redirigir a la página anterior o al dashboard
                const from = location.state?.from?.pathname || '/dashboard';
                navigate(from, { replace: true });
            } else {
                setError('Credenciales inválidas. Por favor, verifica tu email y contraseña.');
            }
        } catch (error) {
            setError('Error al iniciar sesión. Por favor, intenta nuevamente.');
            console.error('Login error:', error);
        } finally {
            setIsLoading(false);
        }
    }

    const goToIndex = () => {
        navigate('/')
    }

  return (
     <div className="relative bg-white w-[900px] h-[600px] flex flex-col items-center justify-center  rounded-lg shadow-lg p-6 mx-auto mt-[100px]">
    <IoMdArrowBack className=" absolute left-20 top-6 text-[#113931] w-[30px] h-[30px] cursor-pointer" onClick={goToIndex} />
<div className="flex flex-col items-center justify-center mb-6">
  <div className="mb-10">
  <h1 className="text-[#113931] text-3xl font-bold">Login</h1>
</div>

<div className="flex flex-col items-center justify-center gap-y-2">
  {error && (
    <Alert severity="error" className="mb-4 w-[300px]">
      {error}
    </Alert>
  )}
  
<form onSubmit={handleSubmit} className='flex flex-col items-center justify-center gap-y-4'>
      <TextField 
        id="email-input" 
        label="Correo electrónico" 
        variant="standard" 
        type="email" 
        name="email" 
        required
        disabled={isLoading}
      />
      <TextField 
        id="password-input" 
        label="Contraseña" 
        variant="standard" 
        type="password" 
        name="password" 
        required
        disabled={isLoading}
      />
     <button 
       type="submit"
       disabled={isLoading}
       className="bg-[rgb(31,133,119)] w-[200px] h-[50px] text-xl rounded-lg text-white font-medium cursor-pointer hover:opacity-80 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center"
     >
       {isLoading ? (
         <CircularProgress size={24} color="inherit" />
       ) : (
         'Iniciar Sesión'
       )}
     </button>
        <p>
            No tienes una cuenta? <span className="text-[rgb(31,133,119)] cursor-pointer" onClick={() => navigate('/signup')}>Registrate</span>
        </p>
</form>
</div>
</div>
      
    </div>
  )
}

export default Login