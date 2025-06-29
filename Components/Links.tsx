'use client'
import Link from 'next/link'
import React, { useMemo } from 'react'
import { usePathname } from 'next/navigation'

type Props = {
    links: {
        name: string
        href: string
    }[]
}

const Links = (props: Props) => {
    const pathname = usePathname()
    const links = useMemo(() => props.links.map((link) => (
        <li key={link.name} className={`font-bold hover:text-green-700 transition-all duration-300 ${pathname === link.href ? 'text-green-700' : ''}`}>
            <Link href={link.href}>{link.name}</Link>
        </li>
    )), [props.links, pathname])

  return (
    <ul className='flex items-center justify-center gap-x-8'>
        {links}
    </ul>
  )
}

export default Links