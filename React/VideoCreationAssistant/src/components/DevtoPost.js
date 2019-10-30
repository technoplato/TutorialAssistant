import React from 'react'
import ReactMarkdown from 'react-markdown'

const MarkdownPost = ({ events }) => (
  <ul>
    {events.map(event => {
      return (
        <li key={event.id}>
          <ReactMarkdown source={event.devto} />
        </li>
      )
    })}
  </ul>
)

export default MarkdownPost
