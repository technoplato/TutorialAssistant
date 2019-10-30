import React, { useState, useEffect } from 'react'
import { Formik } from 'formik'
import { useCookie } from '@use-hook/use-cookie'

import moment from 'moment'

import useEventListener from '../hooks/use-event-listener'
import replaceAll from '../utilities/replace-all'
import RecordingDot from './RecordingDot'

import MyTextField from './MyTextField'
import AbbreviatedEventList from './AbbreviatedEventList'

import { devtoEventTemplate, youtubeEventTemplate } from '../templates'

export default ({ endRecording, events, setEvents }) => {
  const [savedSeconds, saveSeconds] = useCookie('seconds', 0)

  const parsedSeconds = parseInt(savedSeconds)

  const [seconds, setSeconds] = useState(parsedSeconds)
  const [start, setStart] = useState(-1)

  function recordTimestampedEvent({ title, description, screenshotUrl }) {
    let devto = devtoEventTemplate
    let youtube = youtubeEventTemplate

    const id = events.length

    const end = seconds
    const duration = end - start

    const formattedStart = formatTimestamp(start)
    const formattedEnd = formatTimestamp(end)
    const formattedDuration = formatTimestamp(duration)

    const event = {
      id,
      title,
      description,
      start,
      end,
      duration,
      formattedStart,
      formattedEnd,
      formattedDuration,
      screenshotUrl
    }

    Object.entries(event).forEach(([key, value]) => {
      devto = replaceAll(devto, `{${key}}`, value)
      youtube = replaceAll(youtube, `{${key}}`, value)
    })

    setEvents(events => [...events, { devto, youtube, ...event }])

    setStart(-1)
  }

  useEventListener('beforeunload', () => {
    saveSeconds(seconds)
  })

  useEffect(() => {
    const interval = setInterval(() => {
      setSeconds(seconds + 1)
    }, 1000)
    return () => clearInterval(interval)
  })

  useEventListener('keydown', () => {
    if (start === -1) {
      setStart(seconds)
    }
  })

  function formatTimestamp(seconds) {
    return moment.utc(seconds * 1000).format('HH:mm:ss')
  }

  const eventOngoing = start !== -1
  const eventOngoingText = `Event started at ${formatTimestamp(
    start
  )}   Current Duration: ${seconds - start}s`

  const formatted = formatTimestamp(seconds)

  return (
    <div>
      <>
        <RecordingDot formatted={formatted} />
        <button
          className={`button button-primary button-primary-active`}
          onClick={() => {
            setSeconds(0)
            saveSeconds(0)
            endRecording()
          }}
        >
          FINISH RECORDING
        </button>
        {eventOngoing && <div>{eventOngoingText}</div>}
        <div>
          <Formik
            initialValues={{
              title: '',
              screenshotUrl: '',
              description: ''
            }}
            onSubmit={(values, actions) => {
              recordTimestampedEvent(values)
              setStart(-1)
            }}
            render={props => (
              <form onSubmit={props.handleSubmit}>
                <MyTextField name="title" type="text" label="Title" />
                <MyTextField
                  name="screenshotUrl"
                  type="text"
                  label="Screenshot"
                />
                <MyTextField
                  name="description"
                  type="input"
                  label="Description"
                />
                <div>
                  <button type="submit" className={`button button-submit`}>
                    {'Submit'}
                  </button>
                </div>
              </form>
            )}
          />
        </div>

        <button
          onClick={() => {
            setEvents([])
          }}
          className={`button button-clear`}
        >
          {'Clear Events - Cannot Undo'}
        </button>
      </>
      <AbbreviatedEventList events={events} />
    </div>
  )
}
