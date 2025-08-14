import { BrowserRouter, Route, Routes, useLocation } from "react-router-dom"
import Login from "./Pages/Login"
import Index from "./Pages/Index"
import Dashboard from "./Pages/Dashboard"
import Categories from "./Pages/Categories"
import { AuthProvider } from './contexts/AuthContext'
import ProtectedRoute from './Components/ProtectedRoute'
import Transactions from "./Pages/Transactions"
import BudgetPage from "./Pages/Budget"
import SavingsPage from "./Pages/Savings"
import SuggestionsPage from "./Pages/Suggestions"
import AccountPage from "./Pages/Account"
import GlobalChatbot from "./Components/GlobalChatbot"
import Signup from "./Pages/Signup"

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <AppRoutes />
      </BrowserRouter>
    </AuthProvider>
  )
}

// Extrae las rutas y el chatbot a un componente aparte
function AppRoutes() {
  const location = useLocation();
  const hideChatbot = ["/login", "/signup", "/"].includes(location.pathname);

  return (
    <>
      {!hideChatbot && <GlobalChatbot />}
      <Routes>
        <Route path="/" element={<Index/>} />
        <Route path="signup" element={<Signup/>}/>
        <Route path="/login" element={<Login/>} />
        <Route path="/dashboard" element={
          <ProtectedRoute>
            <Dashboard />
          </ProtectedRoute>
        } />
        <Route path="/categories" element={
          <ProtectedRoute>
            <Categories />
          </ProtectedRoute>
        } />
        <Route path="/transactions" element={
          <ProtectedRoute>
            <Transactions />
          </ProtectedRoute>
        } />
        <Route path="/presupuesto" element={
          <ProtectedRoute>
            <BudgetPage />
          </ProtectedRoute>
        } />
        <Route path="/ahorros" element={
          <ProtectedRoute>
            <SavingsPage />
          </ProtectedRoute>
        } />
        <Route path="/sugerencias" element={
          <ProtectedRoute>
            <SuggestionsPage />
          </ProtectedRoute>
        } />
        <Route path="/cuenta" element={
          <ProtectedRoute>
            <AccountPage />
          </ProtectedRoute>
        } />
      </Routes>
    </>
  );
}

export default App
