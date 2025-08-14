'use client'
import { useLocation } from 'react-router-dom'
import { motion, AnimatePresence } from 'framer-motion'
import {Link} from 'react-router-dom'
type Props = {
  links: Array<{
    name: string
    href: string
  }>
  isOpen: boolean
  onClose: () => void
}

const MobileNav = ({ links, isOpen, onClose }: Props) => {
  const pathname = useLocation().pathname

  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: -20 }}
          transition={{ duration: 0.2 }}
          className="absolute top-16 left-0 right-0 bg-white shadow-lg"
        >
          <nav className="container mx-auto px-4 py-4">
            <ul className="flex flex-col space-y-4">
              {links.map((link) => (
                <motion.li
                  key={link.name}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  exit={{ opacity: 0, x: -20 }}
                  transition={{ duration: 0.2 }}
                >
                  <Link
                    to={link.href}
                    onClick={onClose}
                    className={`
                      block py-2 px-4 rounded-lg
                      font-medium transition-colors duration-200
                      ${pathname === link.href
                        ? 'bg-green-50 text-green-700'
                        : 'text-gray-600 hover:bg-gray-50'
                      }
                    `}
                  >
                    {link.name}
                  </Link>
                </motion.li>
              ))}
            </ul>
          </nav>
        </motion.div>
      )}
    </AnimatePresence>
  )
}

export default MobileNav 