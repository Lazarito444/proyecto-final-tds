import React, { useEffect, useState } from "react";
import Header from "../Components/Header";
import SavingServices from "../services/SavingServices";
import type { Saving } from "../Interfaces/SavingInterface";
import {
  Box, Typography, Button, Table, TableBody, TableCell, TableContainer,
  TableHead, TableRow, Paper, TextField, Dialog, DialogTitle, DialogContent,
  DialogActions, IconButton
} from "@mui/material";
import DeleteIcon from "@mui/icons-material/Delete";
import EditIcon from "@mui/icons-material/Edit";
import RefreshIcon from "@mui/icons-material/Refresh";

const SavingsPage = () => {
  const [savings, setSavings] = useState<Saving[]>([]);
  const [loading, setLoading] = useState(false);
  const [open, setOpen] = useState(false);
  const [form, setForm] = useState<Partial<Saving>>({});
  const [editingId, setEditingId] = useState<string | null>(null);

  const fetchSavings = async () => {
    setLoading(true);
    try {
      const res = await SavingServices.getSavings();
      setSavings(res.data);
    } catch {
      // Manejo de error
    }
    setLoading(false);
  };

  useEffect(() => {
    fetchSavings();
  }, []);

  const handleOpen = (saving?: Saving) => {
    setOpen(true);
    if (saving) {
      setForm(saving);
      setEditingId(saving.id);
    } else {
      setForm({});
      setEditingId(null);
    }
  };

  const handleClose = () => {
    setOpen(false);
    setForm({});
    setEditingId(null);
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async () => {
    if (!form.name || !form.targetAmount || !form.targetDate) return;
    if (editingId) {
      await SavingServices.updateSaving(editingId, form);
    } else {
      await SavingServices.createSaving({
        name: form.name,
        targetAmount: Number(form.targetAmount),
        currentAmount: Number(form.currentAmount) || 0,
        targetDate: form.targetDate,
      });
    }
    fetchSavings();
    handleClose();
  };

  const handleDelete = async (id: string) => {
    await SavingServices.deleteSaving(id);
    fetchSavings();
  };

  return (
    <>
      <Header />
      <div className='bg-white w-[95%] h-[600px] flex flex-col items-center rounded-lg shadow-lg mx-auto mt-[100px] md:mt-10 p-4 overflow-auto'>
        <div className='w-full'>
          <Typography variant="h5" align="center" gutterBottom>
            Ahorros
          </Typography>
          <Box className="flex justify-end mb-2">
            <Button variant="contained" color="success" onClick={() => handleOpen()}>
              Nuevo Ahorro
            </Button>
            <IconButton onClick={fetchSavings}><RefreshIcon /></IconButton>
          </Box>
          <TableContainer component={Paper} sx={{ maxHeight: 350 }}>
            <Table stickyHeader>
              <TableHead>
                <TableRow>
                  <TableCell>Nombre</TableCell>
                  <TableCell>Monto objetivo</TableCell>
                  <TableCell>Monto actual</TableCell>
                  <TableCell>Fecha objetivo</TableCell>
                  <TableCell>Acciones</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {savings.map((saving) => (
                  <TableRow key={saving.id}>
                    <TableCell>{saving.name}</TableCell>
                    <TableCell>${saving.targetAmount}</TableCell>
                    <TableCell>${saving.currentAmount}</TableCell>
                    <TableCell>{saving.targetDate?.split("T")[0]}</TableCell>
                    <TableCell>
                      <IconButton onClick={() => handleOpen(saving)}><EditIcon /></IconButton>
                      <IconButton onClick={() => handleDelete(saving.id)}><DeleteIcon /></IconButton>
                    </TableCell>
                  </TableRow>
                ))}
                {savings.length === 0 && (
                  <TableRow>
                    <TableCell colSpan={5} align="center">No hay ahorros registrados.</TableCell>
                  </TableRow>
                )}
              </TableBody>
            </Table>
          </TableContainer>
        </div>
      </div>
      <Dialog open={open} onClose={handleClose}>
        <DialogTitle>{editingId ? "Editar Ahorro" : "Nuevo Ahorro"}</DialogTitle>
        <DialogContent sx={{ display: "flex", flexDirection: "column", gap: 2, minWidth: 300 }}>
          <TextField
            label="Nombre"
            name="name"
            value={form.name || ""}
            onChange={handleChange}
            fullWidth
          />
          <TextField
            label="Monto objetivo"
            name="targetAmount"
            type="number"
            value={form.targetAmount || ""}
            onChange={handleChange}
            fullWidth
          />
          <TextField
            label="Monto actual"
            name="currentAmount"
            type="number"
            value={form.currentAmount || ""}
            onChange={handleChange}
            fullWidth
          />
          <TextField
            label="Fecha objetivo"
            name="targetDate"
            type="date"
            value={form.targetDate ? form.targetDate.split("T")[0] : ""}
            onChange={handleChange}
            InputLabelProps={{ shrink: true }}
            fullWidth
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose}>Cancelar</Button>
          <Button onClick={handleSubmit} variant="contained" color="success">
            {editingId ? "Actualizar" : "Crear"}
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
};

export default SavingsPage;