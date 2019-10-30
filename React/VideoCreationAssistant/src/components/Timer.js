/**
 * Credit: https://upmostly.com/tutorials/build-a-react-timer-component-using-hooks
 */

import React, { useState, useEffect } from 'react'
import useEventListener from '../hooks/use-event-listener'
import { useCookie } from '@use-hook/use-cookie'

import BeforeRecording from './BeforeRecording'
import DuringRecording from './DuringRecording'

import './timer.css'
import AfterRecording from './AfterRecording'

const State = {
  BEFORE_RECORDING: 'BEFORE',
  DURING_RECORDING: 'DURING',
  AFTER_RECORDING: 'AFTER'
}

const Timer = () => {
  const [savedState, saveState] = useCookie('state', State.BEFORE_RECORDING)
  const [state, setState] = useState(savedState)

  const [savedEvents, saveEvents] = useCookie('events', [])
  const parsedEvents = JSON.parse(savedEvents)
  const [events, setEvents] = useState(parsedEvents)

  useEventListener('beforeunload', () => {
    saveState(state)
    saveEvents(JSON.stringify(events))
  })

  useEffect(() => {
    if (state === State.BEFORE_RECORDING) {
      // Reset events if Tutorial Helper is used for two simultaneous recording sessions
      setEvents([])
    }
  }, [state])

  return (
    <div className="app">
      {state === State.BEFORE_RECORDING && (
        <BeforeRecording
          startRecording={() => setState(State.DURING_RECORDING)}
        />
      )}
      {state === State.DURING_RECORDING && (
        <DuringRecording
          events={events}
          setEvents={setEvents}
          endRecording={() => setState(State.AFTER_RECORDING)}
        />
      )}
      {state === State.AFTER_RECORDING && (
        <AfterRecording
          events={events}
          startOver={() => setState(State.BEFORE_RECORDING)}
        />
      )}
    </div>
  )
}

export default Timer
