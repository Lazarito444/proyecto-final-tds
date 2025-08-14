import Profile from './Profile'
import Links from './Links'
import MobileHeader from './MobileHeader'
import { useTheme } from '../contexts/ThemeContext'
import { FaSun, FaMoon } from 'react-icons/fa'

const Header = () => {
  const { isDarkMode, toggleTheme } = useTheme();
  
const links = [
    {
        name: 'Inicio',
        href: '/dashboard'
    },
    {
        name: 'Transacciones',
        href: '/transactions'
    },
    {
        name: 'Presupuesto',
        href: '/presupuesto'
    },
 
    {
        name: 'Sugerencias',
        href: '/sugerencias'
    },
    {
      name:"Categorias",
      href: '/categories'
    },
     {
      name: "Ahorros",
      href: "/ahorros"
    },
]

  return (
    <>
      {/* Desktop Header */}
      <nav className='bg-white w-full h-16 items-center justify-between p-4 hidden md:flex'>
        <img 
          src="/Logo.png" 
          alt="Logo de Financia" 
          width={100} 
          height={40}
          
          className="object-contain"
        />
        <Links links={links} />
        <div className="flex items-center gap-4">
          <button
            onClick={toggleTheme}
            className="p-2 rounded-full hover:bg-gray-100 transition-colors"
            title={isDarkMode ? 'Modo claro' : 'Modo oscuro'}
          >
            {isDarkMode ? (
              <FaSun className="w-5 h-5 text-yellow-500" />
            ) : (
              <FaMoon className="w-5 h-5 text-gray-600" />
            )}
          </button>
          <Profile />
        </div>
      </nav>

      {/* Mobile Header */}
      <MobileHeader links={links} />
    </>
  )
}

export default Header