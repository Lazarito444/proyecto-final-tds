import * as React from 'react';
import AppBar from '@mui/material/AppBar';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import Typography from '@mui/material/Typography';
import Box from '@mui/material/Box';
import TextField from '@mui/material/TextField';
import FormControl from '@mui/material/FormControl';
import InputLabel from '@mui/material/InputLabel';
import Select from '@mui/material/Select';
import MenuItem from '@mui/material/MenuItem';
import Button from '@mui/material/Button';
import CircularProgress from '@mui/material/CircularProgress';
import Alert from '@mui/material/Alert';
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
import Chip from '@mui/material/Chip';
import CategoryServices from '../services/CategoryServices';
import TransactionServices from '../services/TransactionServices';
import { formatDate } from '../utils/functions';
interface Category {
  id: number;
  name: string;
}

interface Transaction {
  id: string;
  categoryId: string;
  description: string;
  amount: number;
  dateTime: string;
  isEarning: boolean;
  categoryName?: string;
}

interface TransactionData {
  categoryId: string;
  description: string;
  amount: number;
  dateTime: string;
  isEarning: boolean;
}


interface TabPanelProps {
  children?: React.ReactNode;
  dir?: string;
  index: number;
  value: number;
}

function TabPanel(props: TabPanelProps) {
  const { children, value, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`full-width-tabpanel-${index}`}
      aria-labelledby={`full-width-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box sx={{ p: 2 }}>
          {children}
        </Box>
      )}
    </div>
  );
}

function a11yProps(index: number) {
  return {
    id: `full-width-tab-${index}`,
    'aria-controls': `full-width-tabpanel-${index}`,
  };
}

const tabs = [
  {
    label: 'Gastos',
    value: 0,
  },
  {
    label: 'Ingresos',
    value: 1,
  },

];
export default function FullWidthTabs() {
  const [value, setValue] = React.useState(0);
  const [mounted, setMounted] = React.useState(false);
  const [categories, setCategories] = React.useState<Category[]>([]);
  const [transactions, setTransactions] = React.useState<Transaction[]>([]);
  const [isLoading, setIsLoading] = React.useState(false);
  const [error, setError] = React.useState<string>('');
  const [success, setSuccess] = React.useState<string>('');

  // Estados para la paginación
  const [page, setPage] = React.useState(0);
  const [rowsPerPage, setRowsPerPage] = React.useState(5);
  const [isEdit,setIsEdit]=React.useState(false);
  const [editTransactionId, setEditTransactionId] = React.useState<string | null>(null);

  // Estados para el formulario
  const [formData, setFormData] = React.useState<TransactionData>({
    categoryId: '',
    description: '',
    amount: 0,
    dateTime: new Date().toISOString(),
    isEarning: false
  });

  const [monthlySummary, setMonthlySummary] = React.useState<any>(null);

  // Nuevos estados para los filtros
  const [filterParams, setFilterParams] = React.useState({
    categoryId: '',
    isEarning: undefined,
    fromDate: '',
    toDate: ''
  });

  React.useEffect(() => {
    const currentMonth = formatDate()
    fetchMonthlySummary(currentMonth);
  }, []);

  const fetchMonthlySummary = async (date: string) => {
    try {
      const response = await TransactionServices.getMonthlySummary(date);
      setMonthlySummary(response.data);
    } catch (error) {
      setError('Error al cargar el resumen mensual');
    }
  };

  React.useEffect(() => {
    setMounted(true);
    loadCategories();
    loadTransactions();
  }, []);

  const loadCategories = async () => {
    try {
      const response = await CategoryServices.getCategories();
      if (response.data) {
        setCategories(response.data);
      }
    } catch (error) {
      console.error('Error loading categories:', error);
      setError('Error al cargar las categorías');
    }
  };

  const loadTransactions = async () => {
    try {
      const response = await TransactionServices.getTransactions();
      if (response.data) {
        setTransactions(response.data);
      }
    } catch (error) {
      console.error('Error loading transactions:', error);
      setError('Error al cargar las transacciones');
    }
  };

  // Combinar transacciones con nombres de categorías
  const transactionsWithCategories = React.useMemo(() => {
    return transactions.map((transaction: Transaction) => ({
      ...transaction,
      categoryName: categories.find(cat => cat.id.toString() === transaction.categoryId)?.name || 'Sin categoría'
    }));
  }, [transactions, categories]);

  const handleRefresh = async () => {
    await Promise.all([loadCategories(), loadTransactions()]);
  };

  const handleChange = (_event: React.SyntheticEvent, newValue: number) => {
    setValue(newValue);
    // Actualizar isEarning basado en la pestaña seleccionada
    setFormData(prev => ({
      ...prev,
      isEarning: newValue === 1 // 0 = Gastos (false), 1 = Ingresos (true)
    }));
  };

  const handleInputChange = (field: keyof TransactionData, value: any) => {
    setFormData(prev => ({
      ...prev,
      [field]: value
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!formData.categoryId || !formData.description || formData.amount <= 0) {
      setError('Por favor completa todos los campos correctamente');
      return;
    }

    setIsLoading(true);
    setError('');
    setSuccess('');

    try {
      if(isEdit && editTransactionId) {
        await TransactionServices.updateTransaction(editTransactionId,formData);
            const currentMonth = formatDate()
    fetchMonthlySummary(currentMonth);

        setSuccess('Transacción actualizada exitosamente');
        setIsEdit(false);
        setEditTransactionId(null);
      } else {
        await TransactionServices.createTransaction(formData);
                  const currentMonth = formatDate()
    fetchMonthlySummary(currentMonth);
        setSuccess(`${formData.isEarning ? 'Ingreso' : 'Gasto'} creado exitosamente`);
      }

      // Limpiar formulario
      setFormData({
        categoryId: '',
        description: '',
        amount: 0,
        dateTime: new Date().toISOString(),
        isEarning: formData.isEarning
      });
      
      // Recargar transacciones
      await loadTransactions();
    } catch (error) {
      console.error('Error creating transaction:', error);
      setError('Error al crear la transacción');
    } finally {
      setIsLoading(false);
    }
  };

  const handleDeleteTransaction = async (id: string) => {
    if (!window.confirm('¿Estás seguro de que quieres eliminar esta transacción?')) {
      return;
    }

    try {
      await TransactionServices.deleteTransaction(id);
      setSuccess('Transacción eliminada exitosamente');
      await loadTransactions();
    } catch (error) {
      console.error('Error deleting transaction:', error);
      setError('Error al eliminar la transacción');
    }
  };

  // Función para cambiar de página
  const handleChangePage = (_event: unknown, newPage: number) => {
    setPage(newPage);
  };

  // Función para cambiar el número de filas por página
  const handleChangeRowsPerPage = (event: React.ChangeEvent<HTMLInputElement>) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };
const handleEdit = (id: string) => {
  const selectedTransaction = transactions.find(tx => tx.id === id);
  setFormData({
    categoryId: selectedTransaction?.categoryId || '',
    description: selectedTransaction?.description || '',
    amount: selectedTransaction?.amount || 0,
    dateTime: selectedTransaction?.dateTime || new Date().toISOString(),
    isEarning: selectedTransaction?.isEarning || false
  });
  setIsEdit(true);
  setEditTransactionId(id);
};
  // Manejar cambio de filtros
  const handleFilterChange = (field: string, value: any) => {
    setFilterParams(prev => ({ ...prev, [field]: value }));
  };

  // Manejar envío de filtros
  const handleFilterSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const response = await TransactionServices.filterTransactions(filterParams);
      setTransactions(response.data);
    } catch (error) {
      setError('Error al filtrar transacciones');
    }
  };

  // Limpiar mensajes después de unos segundos
  React.useEffect(() => {
    if (success || error) {
      const timer = setTimeout(() => {
        setSuccess('');
        setError('');
      }, 5000);
      return () => clearTimeout(timer);
    }
  }, [success, error]);

  if (!mounted) {
    return (
      <Box sx={{ bgcolor: 'background.paper', width: 500 }}>
        <AppBar position="static">
          <Tabs
            value={0}
            indicatorColor="secondary"
            textColor="inherit"
            variant="fullWidth"
            aria-label="full width tabs example"
          >
            {tabs.map((tab) => (
              <Tab key={tab.value} label={tab.label} {...a11yProps(tab.value)} />
            ))}
          </Tabs>
        </AppBar>
        <TabPanel value={0} index={0} >
          <div>
            <h1>Gastos</h1>
          </div>
        </TabPanel>
      </Box>
    );
  }

  return (
    <Box sx={{ bgcolor: 'background.paper', width: '100%', maxWidth: '100%' }}>
      {/* Mensajes de estado */}
      {error && (
        <Alert severity="error" sx={{ mb: 2 }}>
          {error}
        </Alert>
      )}
      {success && (
        <Alert severity="success" sx={{ mb: 2 }}>
          {success}
        </Alert>
      )}
      
      {/* Resumen mensual */}
      {monthlySummary && (
        <Alert severity="info" sx={{ mb: 2 }}>
          <strong>Resumen de {(() => {
            const meses = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 
                          'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
            const mesNumero = parseInt(monthlySummary.month) - 1;
            return meses[mesNumero] || monthlySummary.month;
          })()}:</strong> 
          Total ingresos: ${monthlySummary.totalEarnings || 0} | 
          Total gastos: ${monthlySummary.totalExpenses}
        </Alert>
      )}

      {/* Formulario de filtro - AHORA ARRIBA DE LOS TABS */}
      <form onSubmit={handleFilterSubmit} className="flex gap-2 mb-2">
        <FormControl size="small" sx={{ minWidth: 120 }}>
          <InputLabel>Categoría</InputLabel>
          <Select
            value={filterParams.categoryId}
            label="Categoría"
            onChange={e => handleFilterChange('categoryId', e.target.value)}
          >
            <MenuItem value="">Todas</MenuItem>
            {categories.map(cat => (
              <MenuItem key={cat.id} value={cat.id.toString()}>{cat.name}</MenuItem>
            ))}
          </Select>
        </FormControl>
        <FormControl size="small" sx={{ minWidth: 120 }}>
          <InputLabel>Tipo</InputLabel>
          <Select
            value={filterParams.isEarning === undefined ? '' : String(filterParams.isEarning)}
            label="Tipo"
            onChange={e => handleFilterChange('isEarning', e.target.value === '' ? undefined : e.target.value === 'true')}
          >
            <MenuItem value="">Todos</MenuItem>
            <MenuItem value="true">Ingreso</MenuItem>
            <MenuItem value="false">Gasto</MenuItem>
          </Select>
        </FormControl>
        <TextField
          label="Desde"
          type="date"
          size="small"
          value={filterParams.fromDate}
          onChange={e => handleFilterChange('fromDate', e.target.value)}
          InputLabelProps={{ shrink: true }}
        />
        <TextField
          label="Hasta"
          type="date"
          size="small"
          value={filterParams.toDate}
          onChange={e => handleFilterChange('toDate', e.target.value)}
          InputLabelProps={{ shrink: true }}
        />
        <Button type="submit" variant="contained" size="small" sx={{ backgroundColor: 'rgb(31,133,119)' }}>
          Filtrar
        </Button>
      </form>

      {/* TABS */}
      <AppBar position="static" sx={{ backgroundColor: 'rgb(31,133,119)' }}>
        <Tabs
          value={value}
          onChange={handleChange}
          indicatorColor="secondary"
          textColor="inherit"
          variant="fullWidth"
          aria-label="full width tabs example"
          sx={{
            '& .MuiTab-root': {
              color: 'white',
              '&.Mui-selected': {
                color: 'white',
                fontWeight: 'bold'
              }
            },
            '& .MuiTabs-indicator': {
              backgroundColor: 'white'
            }
          }}
        >
          {tabs.map((tab) => (
            <Tab key={tab.value} label={tab.label} {...a11yProps(tab.value)} />
          ))}
        </Tabs>
      </AppBar>
      
      <TabPanel value={value} index={0}>
        <div className='flex flex-col lg:flex-row gap-4'>
          {/* Formulario */}
          <div className='lg:w-1/3'>
            <div className='bg-gray-50 p-4 rounded-lg'>
              <Typography variant="h6" gutterBottom>
                Registrar Gasto
              </Typography>
              <form onSubmit={handleSubmit} className='flex flex-col gap-3'>
                <FormControl fullWidth required>
                  <InputLabel>Categoría</InputLabel>
                  <Select
                    value={formData.categoryId}
                    onChange={(e) => handleInputChange('categoryId', e.target.value)}
                    label="Categoría"
                    size="small"
                  >
                    {categories.map((category) => (
                      <MenuItem key={category.id} value={category.id.toString()}>
                        {category.name}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
                
                <TextField
                  fullWidth
                  label="Descripción"
                  variant="outlined"
                  value={formData.description}
                  onChange={(e) => handleInputChange('description', e.target.value)}
                  required
                  size="small"
                />
                
                <TextField
                  fullWidth
                  label="Monto"
                  variant="outlined"
                  value={formData.amount}
                  onChange={(e) => handleInputChange('amount', parseFloat(e.target.value) || 0)}
                  required
                  inputProps={{ min: 0.01, step: 0.01 }}
                  size="small"
                />
                
                <TextField
                  fullWidth
                  label="Fecha y Hora"
                  type="datetime-local"
                  variant="outlined"
                  value={formData.dateTime.slice(0, 16)}
                  onChange={(e) => handleInputChange('dateTime', new Date(e.target.value).toISOString())}
                  InputLabelProps={{
                    shrink: true,
                  }}
                  required
                  size="small"
                />
                
                <Button
                  type="submit"
                  variant="contained"
                  disabled={isLoading}
                  size="small"
                  sx={{ 
                    backgroundColor: 'rgb(31,133,119)', 
                    '&:hover': { backgroundColor: 'rgba(31,133,119,0.8)' },
                    mt: 1
                  }}
                >
                  {isLoading ? (
                    <CircularProgress size={20} color="inherit" />
                  ) : (
                    'Registrar Gasto'
                  )}
                </Button>
              </form>
            </div>
          </div>

          {/* Tabla */}
          <div className='lg:w-2/3'>
            <div className='flex justify-between items-center mb-3'>
              <Typography variant="h6">Lista de Gastos</Typography>
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
            
            {isLoading && transactionsWithCategories.length === 0 ? (
              <div className="flex justify-center p-8">
                <CircularProgress />
              </div>
            ) : (
              <TableContainer component={Paper} sx={{ maxHeight: 380 }}>
                <Table stickyHeader sx={{ minWidth: 400 }} aria-label="transacciones table">
                  <TableHead>
                    <TableRow>
                      <TableCell><strong>Descripción</strong></TableCell>
                      <TableCell><strong>Categoría</strong></TableCell>
                      <TableCell><strong>Monto</strong></TableCell>
                      <TableCell><strong>Fecha</strong></TableCell>
                      <TableCell align="right"><strong>Acciones</strong></TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {transactionsWithCategories
                      .filter(transaction => !transaction.isEarning)
                      .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                      .map((transaction) => (
                        <TableRow
                          key={transaction.id}
                          sx={{ 
                            '&:last-child td, &:last-child th': { border: 0 },
                            '&:hover': { backgroundColor: 'rgba(0, 0, 0, 0.04)' }
                          }}
                        >
                          <TableCell>{transaction.description}</TableCell>
                          <TableCell>
                            <Chip 
                              label={transaction.categoryName} 
                              size="small" 
                              color="default"
                            />
                          </TableCell>
                          <TableCell sx={{ color: 'red', fontWeight: 'bold' }}>
                            -${transaction.amount.toFixed(2)}
                          </TableCell>
                          <TableCell>
                            {new Date(transaction.dateTime).toLocaleDateString()}
                          </TableCell>
                          <TableCell align="right">
                            <IconButton 
                              aria-label="edit"
                              onClick={() => handleEdit( transaction.id)}
                              size="small"
                            >
                              <EditIcon />
                            </IconButton>
                            <IconButton 
                              aria-label="delete"
                              onClick={() => handleDeleteTransaction(transaction.id)}
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
                  count={transactionsWithCategories.filter(t => !t.isEarning).length}
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
      </TabPanel>
      
      <TabPanel value={value} index={1}>
        <div className='flex flex-col lg:flex-row gap-4'>
          {/* Formulario */}
          <div className='lg:w-1/3'>
            <div className='bg-gray-50 p-4 rounded-lg'>
              <Typography variant="h6" gutterBottom>
                Registrar Ingreso
              </Typography>
              <form onSubmit={handleSubmit} className='flex flex-col gap-3'>
                <FormControl fullWidth required>
                  <InputLabel>Categoría</InputLabel>
                  <Select
                    value={formData.categoryId}
                    onChange={(e) => handleInputChange('categoryId', e.target.value)}
                    label="Categoría"
                    size="small"
                  >
                    {categories.map((category) => (
                      <MenuItem key={category.id} value={category.id.toString()}>
                        {category.name}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
                
                <TextField
                  fullWidth
                  label="Descripción"
                  variant="outlined"
                  value={formData.description}
                  onChange={(e) => handleInputChange('description', e.target.value)}
                  required
                  size="small"
                />
                
                <TextField
                  fullWidth
                  label="Monto"
                  variant="outlined"
                  value={formData.amount}
                  onChange={(e) => handleInputChange('amount', parseFloat(e.target.value) || 0)}
                  required
                  inputProps={{ min: 0.01, step: 0.01 }}
                  size="small"
                />
                
                <TextField
                  fullWidth
                  label="Fecha y Hora"
                  type="datetime-local"
                  variant="outlined"
                  value={formData.dateTime.slice(0, 16)}
                  onChange={(e) => handleInputChange('dateTime', new Date(e.target.value).toISOString())}
                  InputLabelProps={{
                    shrink: true,
                  }}
                  required
                  size="small"
                />
                
                <Button
                  type="submit"
                  variant="contained"
                  disabled={isLoading}
                  size="small"
                  sx={{ 
                    backgroundColor: 'rgb(31,133,119)', 
                    '&:hover': { backgroundColor: 'rgba(31,133,119,0.8)' },
                    mt: 1
                  }}
                >
                  {isLoading ? (
                    <CircularProgress size={20} color="inherit" />
                  ) : (
                    'Registrar Ingreso'
                  )}
                </Button>
              </form>
            </div>
          </div>

          {/* Tabla */}
          <div className='lg:w-2/3'>
            <div className='flex justify-between items-center mb-3'>
              <Typography variant="h6">Lista de Ingresos</Typography>
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
            
            {isLoading && transactionsWithCategories.length === 0 ? (
              <div className="flex justify-center p-8">
                <CircularProgress />
              </div>
            ) : (
              <TableContainer component={Paper} sx={{ maxHeight: 380 }}>
                <Table stickyHeader sx={{ minWidth: 400 }} aria-label="transacciones table">
                  <TableHead>
                    <TableRow>
                      <TableCell><strong>Descripción</strong></TableCell>
                      <TableCell><strong>Categoría</strong></TableCell>
                      <TableCell><strong>Monto</strong></TableCell>
                      <TableCell><strong>Fecha</strong></TableCell>
                      <TableCell align="right"><strong>Acciones</strong></TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {transactionsWithCategories
                      .filter(transaction => transaction.isEarning)
                      .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                      .map((transaction) => (
                        <TableRow
                          key={transaction.id}
                          sx={{ 
                            '&:last-child td, &:last-child th': { border: 0 },
                            '&:hover': { backgroundColor: 'rgba(0, 0, 0, 0.04)' }
                          }}
                        >
                          <TableCell>{transaction.description}</TableCell>
                          <TableCell>
                            <Chip 
                              label={transaction.categoryName} 
                              size="small" 
                              color="default"
                            />
                          </TableCell>
                          <TableCell sx={{ color: 'green', fontWeight: 'bold' }}>
                            +${transaction.amount.toFixed(2)}
                          </TableCell>
                          <TableCell>
                            {new Date(transaction.dateTime).toLocaleDateString()}
                          </TableCell>
                          <TableCell align="right">
                            <IconButton 
                              aria-label="edit"
                              onClick={() => handleEdit(transaction.id)}
                              size="small"
                            >
                              <EditIcon />
                            </IconButton>
                            <IconButton 
                              aria-label="delete"
                              onClick={() => handleDeleteTransaction(transaction.id)}
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
                  count={transactionsWithCategories.filter(t => t.isEarning).length}
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
      </TabPanel>
    </Box>
  );
}