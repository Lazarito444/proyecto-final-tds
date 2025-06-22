'use client'
import Link from 'next/link'
import React from 'react'
import { usePathname } from 'next/navigation'

type Props = {
    links: {
        name: string
        href: string
    }[]
}

const Links = (props: Props) => {
    const pathname = usePathname()

  return (
    <ul className='flex items-center justify-center gap-x-8'>
        {props.links.map((link) => (
                <li className={`font-bold hover:text-green-700 transition-all duration-300 ${pathname === link.href ? 'text-green-700' : ''}`} key={link.name}>
                <Link href={link.href}>{link.name}</Link>
            </li>
        ))}
    </ul>
  )
}

export default Links