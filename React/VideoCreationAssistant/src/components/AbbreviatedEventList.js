import React from 'react'

export default ({ events }) => {
  return (
    <ul>
      {events.map(({ id, formattedStart, formattedEnd, duration, title }) => {
        return (
          <li
            key={id}
          >{`${formattedStart} - ${formattedEnd} (${duration}s) ==> ${title}`}</li>
        )
      })}
    </ul>
  )
}
