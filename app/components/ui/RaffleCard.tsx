import React from 'react'

const RaffleCard = () => {
    return (
        <div className='h-[300px] bg-slate-700 w-[300px] rounded-md flex flex-col items-center justify-center p-2 gap-2 hover:{h-[310px] w-[310px] delay-200 transition}'>
            <h6> Participents needed: 5</h6>
            <h6> Participents entered: 0</h6>
            <h6> Raffle Deadline: 7 Days</h6>
            <h6> Raffle Status: Closed</h6>
            <h6> Waiting for participents....</h6>
            <h2 className='font-semibold text-2xl mt-4'>Timer</h2>

            <h1 className='font-bold text-5xl'>00 : 00 : 00</h1>


        </div>
    )
}

export default RaffleCard