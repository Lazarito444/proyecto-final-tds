import { useState, useEffect } from 'react'
import { CiMenuBurger } from "react-icons/ci";
import { IoMdClose } from "react-icons/io";
import MobileNav from './MobileNav'
import Profile from './Profile'

type Props = {
  links: Array<{
    name: string
    href: string
  }>
}

const MobileHeader = ({ links }: Props) => {
  const [isOpen, setIsOpen] = useState(false)
  const [isScrolled, setIsScrolled] = useState(false)

  // Manejar el scroll
  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 10)
    }
    window.addEventListener('scroll', handleScroll)
    return () => window.removeEventListener('scroll', handleScroll)
  }, [])

  // Prevenir scroll cuando el menú está abierto
  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden'
    } else {
      document.body.style.overflow = 'unset'
    }
    return () => {
      document.body.style.overflow = 'unset'
    }
  }, [isOpen])

  return (
    <>
      <header 
        className={`
          fixed top-0 left-0 right-0 z-50
          transition-all duration-300 ease-in-out
          ${isScrolled ? 'bg-white shadow-md' : 'bg-transparent'}
          md:hidden
        `}
      >
        <nav className="bg-white">
          <div className="container mx-auto px-4">
            <div className="flex items-center justify-between h-16">
              {/* Logo */}
              <img 
                src="/Logo.png" 
                alt="Logo de Financia" 
                width={100} 
                height={40}
                className="object-contain"
              />

              {/* Botones de acción */}
              <div className="flex items-center gap-x-4">
                <Profile />
                <button
                  onClick={() => setIsOpen(!isOpen)}
                  className="p-2 rounded-lg hover:bg-gray-100 cursor-pointer"
                  aria-label={isOpen ? 'Cerrar menú' : 'Abrir menú'}
                >
                  {isOpen ? (
                    <IoMdClose className="w-6 h-6 text-gray-800" />
                  ) : (
                    <CiMenuBurger className="w-6 h-6 text-gray-800" />
                  )}
                </button>
              </div>
            </div>
          </div>
        </nav>

        {/* Menú móvil */}
        <MobileNav 
          links={links} 
          isOpen={isOpen} 
          onClose={() => setIsOpen(false)}
        />
      </header>

      {/* Overlay */}
      {isOpen && (
        <div 
          className="fixed inset-0 bg-black/50 z-40 md:hidden"
          onClick={() => setIsOpen(false)}
        />
      )}
    </>
  )
}

export default MobileHeader 