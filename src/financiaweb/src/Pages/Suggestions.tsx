import  { useEffect, useState } from "react";
import Header from "../Components/Header";
import AIServices from "../services/AIServices";
import type { Suggestion, Prediction } from "../Interfaces/AIInterface";
import {
  Box, Typography, Paper, CircularProgress, Alert, Button
} from "@mui/material";
import RefreshIcon from "@mui/icons-material/Refresh";

const SuggestionsPage = () => {
  const [suggestions, setSuggestions] = useState<Suggestion>();
  const [predictions, setPredictions] = useState<Prediction>();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const fetchSuggestions = async () => {
    setLoading(true);
    setError("");
    try {
      const res = await AIServices.getSuggestions();
      setSuggestions(res.data);
    } catch {
      setError("Error al cargar sugerencias");
    }
    setLoading(false);
  };

  const fetchPredictions = async () => {
    setLoading(true);
    setError("");
    try {
      const res = await AIServices.getPredictions();
      setPredictions(res.data);
    } catch {
      setError("Error al cargar predicciones");
    }
    setLoading(false);
  };

  useEffect(() => {
    fetchSuggestions();
    fetchPredictions();
  }, []);

  return (
    <>
      <Header />
      <div className='bg-white w-[95%] h-[600px] flex flex-col items-center rounded-lg shadow-lg mx-auto mt-[100px] md:mt-10 p-4 overflow-auto'>
        <div className='w-full flex flex-col lg:flex-row gap-6'>
          {/* Sugerencias */}
          <Box className="lg:w-1/2 flex flex-col gap-2">
            <Typography variant="h6" className="mb-2">Sugerencias Inteligentes</Typography>
            <Button
              variant="outlined"
              size="small"
              startIcon={<RefreshIcon />}
              onClick={fetchSuggestions}
              sx={{ alignSelf: "flex-end", mb: 1 }}
            >
              Refrescar
            </Button>
            {loading && <CircularProgress size={24} />}
            {error && <Alert severity="error">{error}</Alert>}
            <Box className="flex flex-col gap-2">
              {suggestions?.mainSuggestion &&
                <Paper className="p-2" elevation={2}>
                  <h2 className="text-2xl font-bold text-center">Sugerencia Principal</h2>
                  -{suggestions?.mainSuggestion}
                </Paper>
              }
              {suggestions?.sideSuggestions?.map((s: any, index: any) => (
                <Paper key={index} className="p-2" elevation={2}>
                  -{s}
                </Paper>
              ))}
              {(!suggestions?.mainSuggestion || !suggestions?.sideSuggestions?.length) && !loading && (
                <Typography variant="body2" color="text.secondary">No hay sugerencias.</Typography>
              )}
            </Box>
          </Box>

          {/* Predicciones */}
          <Box className="lg:w-1/2 flex flex-col gap-2">
            <Typography variant="h6" className="mb-2">Predicciones IA</Typography>
            <Button
              variant="outlined"
              size="small"
              startIcon={<RefreshIcon />}
              onClick={fetchPredictions}
              sx={{ alignSelf: "flex-end", mb: 1 }}
            >
              Refrescar
            </Button>
            {loading && <CircularProgress size={24} />}
            {error && <Alert severity="error">{error}</Alert>}
            <Box className="flex flex-col gap-2">
              {predictions?.mainPrediction &&
                <Paper className="p-2" elevation={2}>
                  <h2 className="text-2xl font-bold text-center">Predicción Principal</h2>
                  -{predictions?.mainPrediction}
                </Paper>
              }
              {predictions?.sidePredictions?.map((s: any, index: any) => (
                <Paper key={index} className="p-2" elevation={2}>
                  -{s}
                </Paper>
              ))}
              {(!predictions?.mainPrediction || !predictions?.sidePredictions?.length) && !loading && (
                <Typography variant="body2" color="text.secondary">No hay predicciones.</Typography>
              )}
            </Box>
          </Box>
        </div>
      </div>
    </>
  );
};

export default SuggestionsPage;