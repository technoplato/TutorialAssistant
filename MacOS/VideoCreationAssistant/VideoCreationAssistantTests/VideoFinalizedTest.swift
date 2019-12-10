//
// Created by Michael Lustig on 12/4/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import XCTest
@testable import FileWatcher
@testable import VideoCreationAssistant

class VideoFinalizedTest: XCTestCase {

  let EXPORTED_VIDEO_PATHS = [
    "/Users/lustig/foo/bar/baz/video.mp4",
    "/Users/lustig/Desktop/myvids/thisothervideo.mov"
  ]

  func testVideoFinalizedMapsCorrectly() {
    let sut = RecordingEventMapper()

    EXPORTED_VIDEO_PATHS.forEach { eventPath in
      let event = FileWatcherEvent(
        FSEventStreamEventId(1234),
        eventPath,
        FSEventStreamEventFlags(kFSEventStreamEventFlagItemIsFile) | FSEventStreamEventFlags(kFSEventStreamEventFlagItemCreated))

      let mapped = sut.map(event)

      switch mapped {
      case let .finalized(path):
        XCTAssertEqual(path, eventPath)
      default:
        XCTFail("Event was type \"\(mapped)\"; was expecting \"finalized\"")
      }
    }
  }
}