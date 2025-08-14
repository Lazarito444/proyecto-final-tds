import React, { useEffect, useState } from "react";
import Header from "../Components/Header";
import UserAccountServices from "../services/UserAccountServices";
import type { AccountData } from "../services/UserAccountServices";
import { useAuth } from "../contexts/AuthContext";
import {
  Box, Typography, TextField, Button, Avatar, CircularProgress, Alert, MenuItem
} from "@mui/material";
import { useAxesTooltip } from "@mui/x-charts";

const genders = [
  { value: 1, label: "Masculino" },
  { value: 2, label: "Femenino" },
  { value: 3, label: "Otro" }
];

const AccountPage = () => {
  const { user,setPhotoPreviewContext } = useAuth();
  const [form, setForm] = useState<Partial<AccountData>>({});
  const [photoPreview, setPhotoPreview] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [success, setSuccess] = useState("");
  const [error, setError] = useState("");
  // Obtener datos del usuario por el id del token
  useEffect(() => {
    const fetchAccount = async () => {
      if (!user?.id) return;
      setLoading(true);
      try {
        const res = await UserAccountServices.getAccount(user.id);
        setForm(res.data);
        if (res.data.imagePath) {
          setPhotoPreview(res.data?.imagePath);
          setPhotoPreviewContext(res.data?.imagePath)
        }
      } catch {
        setError("Error al cargar datos de cuenta");
      }
      setLoading(false);
    };
    fetchAccount();
  }, [user]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value, files } = e.target;
    if (name === "photoFile" && files && files[0]) {
      setForm(prev => ({ ...prev, photoFile: files[0] }));
      setPhotoPreview(URL.createObjectURL(files[0]));
    } else {
      setForm(prev => ({ ...prev, [name]: value }));
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user?.id) return;
    setLoading(true);
    setError("");
    setSuccess("");
    try {
      await UserAccountServices.updateAccount(user.id, form as AccountData);
      setSuccess("Cuenta actualizada correctamente");
    } catch {
      setError("Error al actualizar cuenta");
    }
    setLoading(false);
  };

  return (
    <>
      <Header />
      <div className='bg-white w-[95%] h-[600px] flex flex-col items-center rounded-lg shadow-lg mx-auto mt-[100px] md:mt-10 p-4 overflow-auto'>
        <div className='w-full max-w-xl mx-auto'>
          <Typography variant="h5" align="center" gutterBottom>
            Mi Cuenta
          </Typography>
          {error && <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>}
          {success && <Alert severity="success" sx={{ mb: 2 }}>{success}</Alert>}
          <form onSubmit={handleSubmit} className="flex flex-col gap-4">
            <Box className="flex flex-col items-center gap-2">
              <Avatar
                src={photoPreview || undefined}
                sx={{ width: 80, height: 80 }}
              />
              <Button variant="outlined" component="label" size="small">
                Cambiar foto
                <input
                  type="file"
                  name="photoFile"
                  accept="image/*"
                  hidden
                  onChange={handleChange}
                />
              </Button>
            </Box>
            <TextField
              label="Nombre completo"
              name="fullName"
              value={form.fullName || ""}
              onChange={handleChange}
              required
              fullWidth
              size="small"
            />
            <TextField
              label="Fecha de nacimiento"
              name="dateOfBirth"
              type="date"
              value={form.dateOfBirth ? form.dateOfBirth.slice(0, 10) : ""}
              onChange={handleChange}
              InputLabelProps={{ shrink: true }}
              required
              fullWidth
              size="small"
            />
            <TextField
              select
              label="Género"
              name="gender"
              value={form.gender || ""}
              onChange={handleChange}
              required
              fullWidth
              size="small"
            >
              {genders.map(g => (
                <MenuItem key={g.value} value={g.value}>{g.label}</MenuItem>
              ))}
            </TextField>
            <TextField
              label="Contraseña actual"
              name="currentPassword"
              type="password"
              value={form.currentPassword || ""}
              onChange={handleChange}
              fullWidth
              size="small"
            />
            <TextField
              label="Nueva contraseña"
              name="password"
              type="password"
              value={form.password || ""}
              onChange={handleChange}
              fullWidth
              size="small"
            />
            <Button
              type="submit"
              variant="contained"
              color="primary"
              disabled={loading}
              sx={{ mt: 2 }}
            >
              {loading ? <CircularProgress size={20} /> : "Guardar cambios"}
            </Button>
          </form>
        </div>
      </div>
    </>
  );
};

export default AccountPage;