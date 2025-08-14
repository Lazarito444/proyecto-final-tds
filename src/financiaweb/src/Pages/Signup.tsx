import React, { useState } from 'react'
import TextField from '@mui/material/TextField';
import { IoMdArrowBack } from "react-icons/io";
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import CircularProgress from '@mui/material/CircularProgress';
import Alert from '@mui/material/Alert';

const Signup = () => {
    const navigate = useNavigate();
    const { signup } = useAuth();
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState<string>('');
    const [success, setSuccess] = useState<string>('');

    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        setIsLoading(true);
        setError('');
        setSuccess('');

        const formData = new FormData(e.currentTarget);
        const fullName = formData.get('fullName') as string;
        const email = formData.get('email') as string;
        const password = formData.get('password') as string;
        const passwordConfirm=formData.get('passwordConfirmation') as string;

        try {
            const result = await signup(fullName, email, password,passwordConfirm);
            if (result) {
                setSuccess('Registro exitoso. Ahora puedes iniciar sesión.');
                setTimeout(() => navigate('/login'), 1500);
            }
             else {
                setError('No se pudo registrar. Intenta con otro correo.');
            }
        } catch (err) {
            setError('Error al registrarse. Por favor, intenta nuevamente.');
        } finally {
            setIsLoading(false);
        }
    };

    const goToIndex = () => {
        navigate('/')
    }

    return (
        <div className="relative bg-white w-[900px] h-[600px] flex flex-col items-center justify-center rounded-lg shadow-lg p-6 mx-auto mt-[100px]">
            <IoMdArrowBack className="absolute left-20 top-6 text-[#113931] w-[30px] h-[30px] cursor-pointer" onClick={goToIndex} />
            <div className="flex flex-col items-center justify-center mb-6">
                <div className="mb-10">
                    <h1 className="text-[#113931] text-3xl font-bold">Registro</h1>
                </div>
                <div className="flex flex-col items-center justify-center gap-y-2">
                    {error && (
                        <Alert severity="error" className="mb-4 w-[300px]">
                            {error}
                        </Alert>
                    )}
                    {success && (
                        <Alert severity="success" className="mb-4 w-[300px]">
                            {success}
                        </Alert>
                    )}
                    <form onSubmit={handleSubmit} className='flex flex-col items-center justify-center gap-y-4'>
                        <TextField
                            id="fullName-input"
                            label="Nombre completo"
                            variant="standard"
                            type="text"
                            name="fullName"
                            required
                            disabled={isLoading}
                        />
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
                          <TextField
                            id="password-input"
                            label="Contraseña"
                            variant="standard"
                            type="password"
                            name="passwordConfirmation"
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
                                'Registrarse'
                            )}
                        </button>
                        <p>
                            ¿Ya tienes una cuenta? <span className="text-[rgb(31,133,119)] cursor-pointer" onClick={() => navigate('/login')}>Inicia sesión</span>
                        </p>
                    </form>
                </div>
            </div>
        </div>
    )
}

export default Signup