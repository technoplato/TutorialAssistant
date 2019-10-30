import React from 'react'

export default ({ startRecording }) => (
  <button
    className={`button button-primary button-primary-active`}
    onClick={startRecording}
  >
    START RECORDING
  </button>
)
