import { Link } from 'react-router-dom'
import React, { useMemo } from 'react'
import { useLocation } from 'react-router-dom'

type Props = {
    links: {
        name: string
        href: string
    }[]
}

const Links = (props: Props) => {
    const location = useLocation()
    const links = useMemo(() => props.links.map((link) => (
        <li key={link.name} className={`font-bold hover:text-green-700 transition-all duration-300 ${location.pathname === link.href ? 'text-green-700' : ''}`}>
            <Link to={link.href}>{link.name}</Link>
        </li>
    )), [props.links, location.pathname])

  return (
    <ul className='flex items-center justify-center gap-x-8'>
        {links}
    </ul>
  )
}

export default Links