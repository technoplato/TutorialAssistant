import React from 'react'
import { CopyToClipboard } from 'react-copy-to-clipboard'

const CopyToClipboardButton = ({ title, copy }) => (
  <CopyToClipboard
    onCopy={() => console.log(`Copied ${copy} to clipboard`)}
    text={copy}
  >
    <button className={`button button-primary button-primary-active`}>
      {title}
    </button>
  </CopyToClipboard>
)

export default CopyToClipboardButton
