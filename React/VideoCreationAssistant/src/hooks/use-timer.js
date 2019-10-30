import { useState } from 'react'

import moment from 'moment'
import useInterval from './use-interval'

export default (doCancel = false, time = 0) => {
  const [elapsed, setElapsed] = useState(time)

  const formattedTime = moment.utc(elapsed * 1000).format('HH:mm:ss')

  useInterval(
    () => {
      setElapsed(elapsed + 1)
    },
    1000,
    doCancel
  )

  return { elapsed, formattedTime }
}
