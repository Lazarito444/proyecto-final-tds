import React from 'react'

type Props = {
    title: string
    value: string
    icon: React.ReactNode
}

const Cards = (props: Props) => {
  return (
    <div className='bg-[#1f8577] text-white w-[300px] h-[100px] rounded-lg shadow-lg p-4'>
        <div className='flex items-center justify-between'>
            <h2 className='text-lg font-bold'>{props.title}</h2>
            <div className='flex items-center justify-center'>{props.icon}</div>
        </div>
        <p className='text-2xl font-bold'>{props.value}</p>
    </div>
  )
}

export default Cards