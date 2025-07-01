import Image from 'next/image'
import Profile from './Profile'
import Links from './Links'
import MobileHeader from './MobileHeader'

const Header = () => {
const links = [
    {
        name: 'Inicio',
        href: '/Dashboard'
    },
    {
        name: 'Transacciones',
        href: '/Transacciones'
    },
    {
        name: 'Presupuesto',
        href: '/presupuesto'
    },
    {
        name: 'Alertas',
        href: '/alertas'
    },
    {
        name: 'Sugerencias',
        href: '/sugerencias'
    },
    {
      name:"Categorias",
      href: '/categorias'
    }
]

  return (
    <>
      {/* Desktop Header */}
      <nav className='bg-white w-full h-16 items-center justify-between p-4 hidden md:flex'>
        <Image 
          src="/Logo.png" 
          alt="Logo de Financia" 
          width={100} 
          height={40}
          priority
          className="object-contain"
        />
        <Links links={links} />
        <Profile />
      </nav>

      {/* Mobile Header */}
      <MobileHeader links={links} />
    </>
  )
}

export default Header