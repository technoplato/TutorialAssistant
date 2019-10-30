//https://www.youtube.com/watch?v=zm5iInPjNwU
import React, { useState } from 'react'
import './recording.css'

import useInterval from '../hooks/use-interval'

export default ({ formatted }) => {
  const [visible, setVisible] = useState(true)
  useInterval(() => {
    setVisible(!visible)
  }, 650)
  const name = visible ? 'fade-in' : 'fade-out'
  return (
    <div>
      <div className="time">{formatted}</div>
      <div className={'vertical-center'}>
        <div className={`red-dot ${name}`} />
        WE'RE RECORDING
      </div>
    </div>
  )
}
