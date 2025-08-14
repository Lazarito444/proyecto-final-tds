import React, { useEffect, useState } from 'react';
import BudgetServices from '../services/BudgetServices';
import type { Budget } from '../Interfaces/BudgetInterface';
import CategoryServices from '../services/CategoryServices';
import {
  Box, Typography, Button, TextField, Table, TableBody, TableCell, TableContainer,
  TableHead, TableRow, Paper, CircularProgress, TablePagination, IconButton, Alert
} from '@mui/material';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import RefreshIcon from '@mui/icons-material/Refresh';
import Header from '../Components/Header';

const BudgetPage = () => {
  const [budgets, setBudgets] = useState<Budget[]>([]);
  const [categories, setCategories] = useState<{id: string, name: string}[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [form, setForm] = useState<Partial<Budget>>({});
  const [editingId, setEditingId] = useState<string | null>(null);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);

  const fetchBudgets = async () => {
    setLoading(true);
    setError('');
    try {
      const res = await BudgetServices.getBudgets();
      // Si la respuesta es un objeto, busca el array
      const arr = Array.isArray(res.data) ? res.data : (res.data.data || []);
      setBudgets(arr);
    } catch (err) {
      setError('Error al cargar presupuestos');
    } finally {
      setLoading(false);
    }
  };

  const fetchCategories = async () => {
    try {
      const res = await CategoryServices.getCategories();
      const arr = Array.isArray(res.data) ? res.data : (res.data.data || []);
      setCategories(arr);
    } catch {
      setCategories([]);
    }
  };

  useEffect(() => {
    fetchBudgets();
    fetchCategories();
  }, []);

  const handleChange = (field: keyof Budget, value: any) => {
    setForm(prev => ({ ...prev, [field]: value }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    setSuccess('');
    try {
      const payload = {
        categoryId: form.categoryId,
        startDate: form.startDate,
        endDate: form.endDate,
        isRecurring: !!form.isRecurring,
        maximumAmount: Number(form.maximumAmount),
      };
      if (editingId) {
        await BudgetServices.updateBudget(editingId, payload);
        setSuccess('Presupuesto actualizado');
      } else {
        await BudgetServices.createBudget(payload);
        setSuccess('Presupuesto creado');
      }
      setForm({});
      setEditingId(null);
      fetchBudgets();
    } catch {
      setError('Error al guardar presupuesto');
    } finally {
      setLoading(false);
    }
  };

  const handleEdit = (budget: Budget) => {
    setForm(budget);
    setEditingId(budget.id);
  };

  const handleDelete = async (id: string) => {
    if (!window.confirm('¿Eliminar presupuesto?')) return;
    setLoading(true);
    setError('');
    try {
      await BudgetServices.deleteBudget(id);
      setSuccess('Presupuesto eliminado');
      fetchBudgets();
    } catch {
      setError('Error al eliminar presupuesto');
    } finally {
      setLoading(false);
    }
  };

  const handleRefresh = () => {
    fetchBudgets();
  };

  const handleChangePage = (_: any, newPage: number) => setPage(newPage);
  const handleChangeRowsPerPage = (e: any) => {
    setRowsPerPage(parseInt(e.target.value, 10));
    setPage(0);
  };

  return (
    <>
    <Header/>
    <div className='bg-white w-[95%] h-[600px] flex flex-col items-center rounded-lg shadow-lg mx-auto mt-[100px] md:mt-10 p-4 overflow-auto'>
      <div className='w-full'>
        <h1 className='text-2xl font-bold text-center mb-4'>Presupuestos</h1>
        <Box className="flex flex-col lg:flex-row gap-4 w-full">
          <Box className="lg:w-1/3 bg-gray-50 p-4 rounded-lg">
            <Typography variant="h6" gutterBottom>{editingId ? 'Editar' : 'Nuevo'} Presupuesto</Typography>
            <form onSubmit={handleSubmit} className="flex flex-col gap-3">
              <TextField
                select
                label="Categoría"
                value={form.categoryId || ''}
                onChange={e => handleChange('categoryId', e.target.value)}
                required
                size="small"
                fullWidth
                slotProps={{ select: { native: true } }}
              >
                <option value="" disabled>Seleccione una categoría</option>
                {categories.map(cat => (
                  <option key={cat.id} value={cat.id}>{cat.name}</option>
                ))}
              </TextField>
              <TextField
                label="Fecha inicio"
                type="datetime-local"
                value={form.startDate ? form.startDate.slice(0, 16) : ''}
                onChange={e => handleChange('startDate', e.target.value)}
                required
                size="small"
                fullWidth
                InputLabelProps={{ shrink: true }}
              />
              <TextField
                label="Fecha fin"
                type="datetime-local"
                value={form.endDate ? form.endDate.slice(0, 16) : ''}
                onChange={e => handleChange('endDate', e.target.value)}
                required
                size="small"
                fullWidth
                InputLabelProps={{ shrink: true }}
              />
              <TextField
                label="Monto máximo"
                type="number"
                value={form.maximumAmount || ''}
                onChange={e => handleChange('maximumAmount', e.target.value)}
                required
                size="small"
                fullWidth
              />
              <Box className="flex items-center gap-2">
                <Typography variant="body2">¿Recurrente?</Typography>
                <input
                  type="checkbox"
                  checked={!!form.isRecurring}
                  onChange={e => handleChange('isRecurring', e.target.checked)}
                  style={{ width: 18, height: 18 }}
                />
              </Box>
              <Button type="submit" variant="contained" color="primary" size="small" disabled={loading}>{loading ? <CircularProgress size={20} /> : (editingId ? 'Actualizar' : 'Crear')}</Button>
              {editingId && <Button variant="text" size="small" onClick={() => { setForm({}); setEditingId(null); }}>Cancelar</Button>}
            </form>
          </Box>
          <Box className="lg:w-2/3">
            <Box className="flex justify-between items-center mb-3">
              <Typography variant="h6">Lista de Presupuestos</Typography>
              <Button startIcon={<RefreshIcon />} onClick={handleRefresh} variant="outlined" size="small" disabled={loading}>Refrescar</Button>
            </Box>
            {loading && budgets.length === 0 ? (
              <Box className="flex justify-center p-8"><CircularProgress /></Box>
            ) : (
              <TableContainer component={Paper} sx={{ maxHeight: 320 }}>
                <Table stickyHeader size="small">
                  <TableHead>
                    <TableRow>
                      <TableCell><strong>Categoría</strong></TableCell>
                      <TableCell><strong>Máximo</strong></TableCell>
                      <TableCell><strong>Inicio</strong></TableCell>
                      <TableCell><strong>Fin</strong></TableCell>
                      <TableCell><strong>Recurrente</strong></TableCell>
                      <TableCell align="right"><strong>Acciones</strong></TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {budgets.slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage).map(budget => (
                      <TableRow key={budget.id}>
                        <TableCell>{categories.find(cat => cat.id === budget.categoryId)?.name || budget.categoryId}</TableCell>
                        <TableCell>${budget.maximumAmount?.toFixed(2)}</TableCell>
                        <TableCell>{new Date(budget.startDate).toLocaleDateString()}</TableCell>
                        <TableCell>{new Date(budget.endDate).toLocaleDateString()}</TableCell>
                        <TableCell>{budget.isRecurring ? 'Sí' : 'No'}</TableCell>
                        <TableCell align="right">
                          <IconButton aria-label="edit" size="small" onClick={() => handleEdit(budget)}><EditIcon /></IconButton>
                          <IconButton aria-label="delete" size="small" color="error" onClick={() => handleDelete(budget.id)}><DeleteIcon /></IconButton>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
                <TablePagination
                  rowsPerPageOptions={[5, 10, 25]}
                  component="div"
                  count={budgets.length}
                  rowsPerPage={rowsPerPage}
                  page={page}
                  onPageChange={handleChangePage}
                  onRowsPerPageChange={handleChangeRowsPerPage}
                  labelRowsPerPage="Filas por página:"
                  labelDisplayedRows={({ from, to, count }) => `${from}-${to} de ${count !== -1 ? count : `más de ${to}`}`}
                />
              </TableContainer>
            )}
          </Box>
        </Box>
      </div>
    </div>
    </>

  );
};

export default BudgetPage;
