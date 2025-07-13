# FinancIA - Plataforma de Finanzas Personales Inteligente

FinancIA es una solución integral para la gestión y análisis de finanzas personales, diseñada para ayudar a los usuarios a controlar sus gastos, establecer metas financieras y recibir recomendaciones personalizadas mediante Inteligencia Artificial (IA).

## Tecnologías Utilizadas
- **Backend:** ASP.NET Core
- **Frontend Web:** React
- **Aplicación Móvil:** Flutter
- **Base de Datos:** SQL Server (sugerido)
- **Notificaciones en Tiempo Real:** SignalR
- **Mensajería Asíncrona:** RabbitMQ
- **Seguridad:** OAuth, 2FA, Encriptación AES
- **IA y Machine Learning:** Clasificación automática, recomendaciones financieras y análisis predictivo

---

## Características Principales

### 1. Gestión de Usuarios
- Registro e inicio de sesión con correo electrónico y contraseña.
- Opcional: Autenticación mediante OAuth (Google, Apple, etc.).
- Perfil editable: nombre, ingresos, moneda preferida, etc.

### 2. Ingreso de Datos Financieros
- Registro manual de ingresos y gastos.
- Clasificación automática por categorías: comida, transporte, entretenimiento, entre otras.

### 3. Visualización de Datos
- Dashboard interactivo con resumen de ingresos, gastos y saldo.
- Gráficas dinámicas:
  - Gasto mensual por categoría.
  - Comparativa de ingresos vs gastos.
  - Evolución del ahorro.

### 4. Establecimiento de Metas
- Crear metas financieras (ahorro, pago de deudas, etc.).
- Asociar metas a cuentas específicas.
- Seguimiento visual del progreso.

### 5. Notificaciones Inteligentes
- Alertas cuando se supera el presupuesto.
- Recordatorios para registrar gastos.
- Sugerencias automáticas generadas por IA.

### 6. Seguridad y Privacidad
- Encriptación de datos en tránsito y en reposo.
- Autenticación de dos factores (2FA).
- Bloqueo por huella o PIN en dispositivos móviles.

### 7. Gestión de Presupuestos
- Creación de presupuestos mensuales por categoría.
- Seguimiento automático de gastos vs presupuestos.
- Alertas de presupuesto próximo a superar.

### 8. Integración Bancaria (Tentativo)
- Conexión segura con APIs bancarias (Plaid, SaltEdge, Belvo, etc.).
- Importación periódica y automática de transacciones.
- Verificación automática de duplicados.

### 9. Historial Financiero y Exportaciones
- Visualización de historial financiero con filtrado avanzado.
- Exportación a Excel o PDF por rangos de fecha, categorías y montos.

### 10. Chatbot Asistente Financiero (con IA)
- Chat conversacional con IA para consultas financieras.
- Ejemplos de consultas:
  - "¿Cuánto gasté en comida este mes?"
  - "¿Cómo puedo ahorrar más?"
- Soporte de entrada por voz (speech-to-text) [Tentativo].

### 11. Soporte Multimoneda
- Gestión de monedas locales y extranjeras.
- Conversión automática con tasas de cambio actualizadas.
- Visualización de balances multimoneda.

### 12. Soporte de Temas Oscuro/Claro
- Cambio de tema disponible en configuración.

### 13. Soporte Multi-idioma
- Idiomas disponibles: Español e Inglés.
- Cambio dinámico desde configuración.

### 14. Recordatorios y Calendario Financiero
- Calendario con eventos financieros.
- Notificaciones push y sincronización con el calendario del dispositivo.

### 15. Perfil Financiero del Usuario
- Perfil dinámico generado por IA (ahorrador, gastador, balanceado, etc.).
- Recomendaciones personalizadas según el perfil financiero.

### 16. Análisis Comparativo
- Comparación de ingresos y gastos entre diferentes períodos (meses/años).
- Identificación de tendencias de gasto.

### 17. Análisis de Estacionalidad
- Detección automática de patrones de gasto estacionales.
- Recomendaciones predictivas basadas en estacionalidad.

---