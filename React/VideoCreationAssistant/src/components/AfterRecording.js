import React, { useState, useEffect } from 'react'
import CopyToClipboardButton from './CopyToClipboardButton'
import DevtoPost from './DevtoPost'

import { devtoPostTemplate } from '../templates'
import { Formik, Field, Form } from 'formik'
import replaceAll from '../utilities/replace-all'

const generateBodies = events => {
  const devto = events.reduce((str, event) => {
    return `${str}\n\n${event.devto}`
  })

  const youtube = events.reduce((str, event) => {
    return `${str}\n\n${event.youtube}`
  })

  return { devto, youtube }
}

const parseTweetId = tweetLink => tweetLink.split('status/')[1]

const generatePosts = (youtubeId, devtoPostLink, tweetLink, events) => {
  const { devto, youtube } = generateBodies(events)

  console.log('L26 devToPostBodyMarkdown ===', devto.devto)

  const postContent = {
    postTitle: 'Im having a load of fun doing this',
    tweetId: parseTweetId(tweetLink),
    youtubeId,
    devtoPostBodyMarkdown: devto.devto
  }

  let dtp = devtoPostTemplate

  Object.entries(postContent).forEach(([key, value]) => {
    dtp = replaceAll(dtp, `{${key}}`, value)
  })

  return dtp
}

const youtubeTemplate = 'https://www.youtube.com/watch?v={youtubeId}'

const youtubeLink = id => `${youtubeTemplate.replace(`{${id}}`)}`

const generateTweet = (youtubeId, devtoPostLink) => {
  return `
  This is a placeholder Tweet #reactjs #react #tutorials
  
  // TODO URL shorten these
  
  ${devtoPostLink}
  ${youtubeLink(youtubeId)}`
}

const AfterRecording = ({ events, startOver }) => {
  const [complete, setComplete] = useState(false)

  const [youtubeId, setYoutubeId] = useState('')
  const [devtoPostLink, setDevtoPostLink] = useState('')
  const [tweetLink, setTweetLink] = useState('')

  const [devtoPost, setDevtoPost] = useState('')

  const [tweet, setTweet] = useState('')

  useEffect(() => {
    if (youtubeId && devtoPostLink) {
      if (tweetLink) {
        const devto = generatePosts(youtubeId, devtoPostLink, tweetLink, events)
        setDevtoPost(devto)
        setComplete(true)
      } else {
        setTweet(generateTweet(youtubeId, devtoPostLink))
      }
    }
  }, [youtubeId, devtoPostLink, tweetLink])

  return (
    <div>
      <div onClick={startOver}>Done</div>

      {!complete && (
        <>
          <div>
            <p>
              Okay, you're done creating the video. Now we just need to do a
              couple more things and you're golden. Once you add a YouTube ID
              and a Dev.to post link, we'll create a Tweet for you.
            </p>
            <div>{`YouTube Video ID: ${youtubeId || 'empty'}`}</div>
            <div>{`Dev.to Post Link: ${devtoPostLink || 'empty'}`}</div>
            <div>{`Tweet: ${tweet || 'empty'}`}</div>

            <div>{`Tweet Link: ${tweetLink || 'empty'}`}</div>
            {tweet && (
              <CopyToClipboardButton copy={tweet} title={'Copy Tweet'} />
            )}
          </div>
          <div>
            <Formik initialValues={{ youtubeId: '', devtoPostLink: '' }}>
              {() => (
                <Form>
                  <Field
                    title={'YouTube Id'}
                    value={youtubeId}
                    onChange={e => setYoutubeId(e.target.value)}
                    type="text"
                    name="youtubeId"
                  />
                  <Field
                    value={devtoPostLink}
                    onChange={e => setDevtoPostLink(e.target.value)}
                    type="text"
                    name="devtoPostLink"
                  />
                  <Field
                    value={tweetLink}
                    onChange={e => setTweetLink(e.target.value)}
                    type="text"
                    name="tweetLink"
                  />
                </Form>
              )}
            </Formik>
          </div>
        </>
      )}
      {complete && (
        <>
          <CopyToClipboardButton
            title={'Copy Devto Post to Clipboard'}
            copy={devtoPost}
          />

          {/*<div>*/}
          {/*  <CopyToClipboardButton*/}
          {/*    title={'Copy YouTube Description to Clipboard'}*/}
          {/*    copy={youtube}*/}
          {/*  />*/}
          {/*</div>*/}
          {/*<DevtoPost events={events} />*/}
        </>
      )}
    </div>
  )
}

export default AfterRecording
