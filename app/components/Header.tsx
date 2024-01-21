import Link from 'next/link'
import React from 'react'
import Button from './ui/Button'

const Header = () => {
    return (
        <nav className='flex flex-row justify-around h-20 w-[100%] items-center bg-slate-950 sticky'>
            <div>FairDraw</div>
            <div className='flex flex-row gap-4 items-baseline'>
                <Link href={"/"}>How it works</Link>
                <Link href={"/"}>Winners</Link>
                <Link href={"/"}>About</Link>
                <Button buttonText="Connect" />
            </div>
        </nav>
    )
}

export default Header