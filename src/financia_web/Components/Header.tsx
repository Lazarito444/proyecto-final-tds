import Image from 'next/image'
import Profile from './Profile'
import Links from './Links'

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
    }
]

  return (
    <>
    <nav className='bg-white w-full h-16 flex items-center justify-between p-4'>
        <Image src="/Logo.png" alt="logo" width={100} height={100} priority />
        <Links links={links} />
        <Profile />
      </nav>
    </>
  )
}

export default Header