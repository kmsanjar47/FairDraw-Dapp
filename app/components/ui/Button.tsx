import React from 'react'

const Button = (ButtonProps: { buttonText: string }) => {
    return (
        <button className='px-6 py-2 ml-6 bg-slate-400 items-center hover:bg-slate-600 rounded-lg'>{ButtonProps.buttonText}</button>
    )
}

export default Button