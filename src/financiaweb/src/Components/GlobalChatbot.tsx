import React, { useState, useRef } from "react";
import AIServices from "../services/AIServices";
import { Box, IconButton, Paper, TextField, Typography, CircularProgress, Fab } from "@mui/material";
import ChatIcon from "@mui/icons-material/Chat";
import CloseIcon from "@mui/icons-material/Close";
import SendIcon from "@mui/icons-material/Send";

const GlobalChatbot = () => {
  const [open, setOpen] = useState(false);
  const [chat, setChat] = useState<{ role: "user" | "assistant"; content: string }[]>([]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);
  const chatEndRef = useRef<HTMLDivElement>(null);

  const handleSend = async () => {
    if (!input.trim()) return;
    setLoading(true);
    setChat((prev) => [...prev, { role: "user", content: input }]);
    try {
      const res = await AIServices.sendChatMessage(input);
      setChat((prev) => [
        ...prev,
        { role: "assistant", content: res.data?.aiResponse || "Sin respuesta de la IA." }
      ]);
      setInput("");
    } catch {
      setChat((prev) => [
        ...prev,
        { role: "assistant", content: "Error al comunicarse con la IA." }
      ]);
    }
    setLoading(false);
    setTimeout(() => chatEndRef.current?.scrollIntoView({ behavior: "smooth" }), 100);
  };

  return (
    <>
      {!open && (
        <Fab
          color="primary"
          aria-label="Abrir chatbot"
          onClick={() => setOpen(true)}
          sx={{
            position: "fixed",
            bottom: 32,
            right: 32,
            zIndex: 1200
          }}
        >
          <ChatIcon />
        </Fab>
      )}
      {open && (
        <Paper
          elevation={6}
          sx={{
            position: "fixed",
            bottom: 32,
            right: 32,
            width: 340,
            height: 440,
            display: "flex",
            flexDirection: "column",
            zIndex: 1300
          }}
        >
          <Box sx={{ display: "flex", alignItems: "center", p: 1, borderBottom: 1, borderColor: "divider" }}>
            <Typography variant="subtitle1" sx={{ flexGrow: 1 }}>Chatbot IA</Typography>
            <IconButton size="small" onClick={() => setOpen(false)}>
              <CloseIcon />
            </IconButton>
          </Box>
          <Box sx={{ flex: 1, overflowY: "auto", p: 1, bgcolor: "#f9f9f9" }}>
            {chat.length === 0 && (
              <Typography variant="body2" color="text.secondary" align="center" sx={{ mt: 2 }}>
                ¡Hazle una pregunta financiera a la IA!
              </Typography>
            )}
            {chat.map((msg, idx) => (
              <Box
                key={idx}
                sx={{
                  alignSelf: msg.role === "user" ? "flex-end" : "flex-start",
                  background: msg.role === "user" ? "#e0f7fa" : "#f1f8e9",
                  borderRadius: 2,
                  px: 2,
                  py: 1,
                  mb: 1,
                  maxWidth: "80%",
                }}
              >
                <Typography variant="body2" fontWeight={msg.role === "user" ? 600 : 400}>
                  {msg.content}
                </Typography>
              </Box>
            ))}
            <div ref={chatEndRef} />
          </Box>
          <Box component="form"
            onSubmit={e => { e.preventDefault(); handleSend(); }}
            sx={{ display: "flex", gap: 1, p: 1, borderTop: 1, borderColor: "divider" }}
          >
            <TextField
              value={input}
              onChange={e => setInput(e.target.value)}
              placeholder="Escribe tu pregunta..."
              size="small"
              fullWidth
              disabled={loading}
            />
            <IconButton type="submit" color="primary" disabled={loading || !input.trim()}>
              {loading ? <CircularProgress size={20} /> : <SendIcon />}
            </IconButton>
          </Box>
        </Paper>
      )}
    </>
  );
};

export default GlobalChatbot;