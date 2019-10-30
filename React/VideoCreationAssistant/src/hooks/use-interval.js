/**
 * Credit: https://overreacted.io/making-setinterval-declarative-with-react-hooks/
 */
import { useEffect, useRef } from 'react'

export default (callback, delay, cancel) => {
  const savedCallback = useRef()

  // Remember the latest callback.
  useEffect(() => {
    savedCallback.current = callback
  }, [callback])

  // Set up the interval.
  useEffect(() => {
    function tick() {
      savedCallback.current()
    }
    if (delay !== null && !cancel) {
      let id = setInterval(tick, delay)
      return () => clearInterval(id)
    }
  }, [delay, cancel])
}
