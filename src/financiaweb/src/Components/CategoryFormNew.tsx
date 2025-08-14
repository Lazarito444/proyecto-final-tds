import React, { useState, useEffect } from 'react'
import TextField from '@mui/material/TextField';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';
import IconButton from '@mui/material/IconButton';
import DeleteIcon from '@mui/icons-material/Delete';
import EditIcon from '@mui/icons-material/Edit';
import RefreshIcon from '@mui/icons-material/Refresh';
import TablePagination from '@mui/material/TablePagination';
import Button from '@mui/material/Button';
import CircularProgress from '@mui/material/CircularProgress';
import Alert from '@mui/material/Alert';
import CategoryServices from '../services/CategoryServices';

type Category = {
  id: number;
  name: string;
}


const CategoryForm = () => {
    const [categories, setCategories] = useState<Category[]>([]);
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState<string>('');
    const [success, setSuccess] = useState<string>('');
    const [category, setCategory] = useState<string>('');
    const [isEditing, setIsEditing] = useState<boolean>(false);
    const [editingCategoryId, setEditingCategoryId] = useState<number | null>(null);

    // Estados para la paginación
    const [page, setPage] = useState(0);
    const [rowsPerPage, setRowsPerPage] = useState(5);

    // Cargar categorías al montar el componente
    useEffect(() => {
        loadCategories();
    }, []);

    const loadCategories = async () => {
        setIsLoading(true);
        setError('');
        try {
            const response = await CategoryServices.getCategories();
            if (response.data) {
                setCategories(response.data);
            }
        } catch (error) {
            console.error('Error loading categories:', error);
            setError('Error al cargar las categorías');
        } finally {
            setIsLoading(false);
        }
    };

    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault()
        const formData = new FormData(e.currentTarget);
        const name = formData.get('name') as string;
        
        if (!name.trim()) return;
        
        setIsLoading(true);
        setError('');
        setSuccess('');
        
        try {
            if (isEditing && editingCategoryId) {
                // Actualizar categoría existente
                await CategoryServices.updateCategory(editingCategoryId, name.trim());
                setSuccess('Categoría actualizada exitosamente');
                setIsEditing(false);
                setEditingCategoryId(null);
                setCategory('');
            } else {
                // Crear nueva categoría
                await CategoryServices.createCategory(name.trim());
                setSuccess('Categoría creada exitosamente');
                setCategory('');
            }
            document.querySelector('form')?.reset(); // Limpiar el formulario
            await loadCategories(); // Recargar la lista
        } catch (error) {
            console.error('Error creating category:', error);
            setError('Error al crear la categoría');
        } finally {
            setIsLoading(false);
        }
    }

    const handleDelete = async (id: number) => {
        if (!window.confirm('¿Estás seguro de que quieres eliminar esta categoría?')) {
            return;
        }

        setError('');
        setSuccess('');
        
        try {
            await CategoryServices.deleteCategory(id);
            setSuccess('Categoría eliminada exitosamente');
            await loadCategories(); // Recargar la lista
        } catch (error) {
            console.error('Error deleting category:', error);
            setError('Error al eliminar la categoría');
        }
    }

    const handleRefresh = async () => {
        await loadCategories();
    }

    // Función para cambiar de página
    const handleChangePage = (_event: unknown, newPage: number) => {
        setPage(newPage);
    };

    // Función para cambiar el número de filas por página
    const handleChangeRowsPerPage = (event: React.ChangeEvent<HTMLInputElement>) => {
        setRowsPerPage(parseInt(event.target.value, 10));
        setPage(0);
    };

    // Calcular las categorías a mostrar según la paginación
    const paginatedCategories = categories.slice(
        page * rowsPerPage,
        page * rowsPerPage + rowsPerPage
    );
    const handleEdit = (id: number) => {
        setIsEditing(true);
        setEditingCategoryId(id);
        const categoryToEdit = categories.find(cat => cat.id === id);
        setCategory(categoryToEdit?.name || '');
    };

    // Limpiar mensajes después de unos segundos
    useEffect(() => {
        if (success || error) {
            const timer = setTimeout(() => {
                setSuccess('');
                setError('');
            }, 5000);
            return () => clearTimeout(timer);
        }
    }, [success, error]);

    return (
        <div className='w-full max-w-7xl'>
            {/* Mensajes de estado */}
            {error && (
                <Alert severity="error" className="mb-4">
                    {error}
                </Alert>
            )}
            {success && (
                <Alert severity="success" className="mb-4">
                    {success}
                </Alert>
            )}

            <div className='flex flex-col lg:flex-row gap-8'>
                {/* Formulario */}
                <div className='lg:w-1/3'>
                    <div className='bg-gray-50 p-6 rounded-lg'>
                        <h2 className='text-xl font-semibold mb-4'>
                            {isEditing ? 'Editar Categoría' : 'Crear Nueva Categoría'}
                        </h2>
                        <form onSubmit={handleSubmit} className='flex flex-col gap-y-4'>
                            <TextField 
                                id="category-name" 
                                label="Nombre de la categoría" 
                                variant="outlined" 
                                name="name" 
                                required
                                fullWidth
                                size="small"
                                value={category}
                                onChange={(e) => setCategory(e.target.value)}
                                disabled={isLoading}
                            />
                            <Button 
                                type="submit"
                                variant="contained"
                                disabled={isLoading}
                                sx={{ 
                                    backgroundColor: 'rgb(31,133,119)', 
                                    '&:hover': { backgroundColor: 'rgba(31,133,119,0.8)' },
                                    height: '48px'
                                }}
                            >
                                {isLoading ? (
                                    <CircularProgress size={24} color="inherit" />
                                ) : (
                                    isEditing ? 'Actualizar Categoría' : 'Crear Categoría'
                                )}
                            </Button>
                            
                            {isEditing && (
                                <Button 
                                    type="button"
                                    variant="outlined"
                                    onClick={() => {
                                        setIsEditing(false);
                                        setEditingCategoryId(null);
                                        setCategory('');
                                    }}
                                    disabled={isLoading}
                                    sx={{ height: '48px' }}
                                >
                                    Cancelar
                                </Button>
                            )}
                        </form>
                    </div>
                </div>

                {/* Tabla */}
                <div className='lg:w-2/3'>
                    <div className='flex justify-between items-center mb-4'>
                        <h2 className='text-xl font-semibold'>Lista de Categorías</h2>
                        <Button
                            startIcon={<RefreshIcon />}
                            onClick={handleRefresh}
                            variant="outlined"
                            size="small"
                            disabled={isLoading}
                        >
                            Refrescar
                        </Button>
                    </div>
                    
                    {isLoading && categories.length === 0 ? (
                        <div className="flex justify-center p-8">
                            <CircularProgress />
                        </div>
                    ) : (
                        <TableContainer component={Paper}>
                            <Table sx={{ minWidth: 400 }} aria-label="categorías table">
                                <TableHead>
                                    <TableRow>
                                        <TableCell><strong>ID</strong></TableCell>
                                        <TableCell><strong>Nombre</strong></TableCell>
                                        <TableCell align="right"><strong>Acciones</strong></TableCell>
                                    </TableRow>
                                </TableHead>
                                <TableBody>
                                    {paginatedCategories.map((category) => (
                                        <TableRow
                                            key={category.id}
                                            sx={{ 
                                                '&:last-child td, &:last-child th': { border: 0 },
                                                '&:hover': { backgroundColor: 'rgba(0, 0, 0, 0.04)' }
                                            }}
                                        >
                                            <TableCell component="th" scope="row">
                                                {category.id}
                                            </TableCell>
                                            <TableCell>{category.name}</TableCell>
                                            <TableCell align="right">
                                                <IconButton 
                                                    aria-label="edit"
                                                    onClick={() => handleEdit(category.id)}
                                                    size="small"
                                                >
                                                    <EditIcon />
                                                </IconButton>
                                                <IconButton 
                                                    aria-label="delete"
                                                    onClick={() => handleDelete(category.id)}
                                                    size="small"
                                                    color="error"
                                                >
                                                    <DeleteIcon />
                                                </IconButton>
                                            </TableCell>
                                        </TableRow>
                                    ))}
                                </TableBody>
                            </Table>
                            
                            {/* Paginación */}
                            <TablePagination
                                rowsPerPageOptions={[5, 10, 25]}
                                component="div"
                                count={categories.length}
                                rowsPerPage={rowsPerPage}
                                page={page}
                                onPageChange={handleChangePage}
                                onRowsPerPageChange={handleChangeRowsPerPage}
                                labelRowsPerPage="Filas por página:"
                                labelDisplayedRows={({ from, to, count }) =>
                                    `${from}-${to} de ${count !== -1 ? count : `más de ${to}`}`
                                }
                            />
                        </TableContainer>
                    )}
                </div>
            </div>
        </div>
    )
}

export default CategoryForm
