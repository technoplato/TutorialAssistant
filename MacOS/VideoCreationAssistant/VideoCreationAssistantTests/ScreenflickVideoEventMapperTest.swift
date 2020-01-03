//
// Created by Michael Lustig on 12/4/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import XCTest
@testable import FileWatcher
@testable import VideoCreationAssistant

class ScreenflickVideoEventMapperTest: XCTestCase {

  let FAKE_MOVIE_PATH = RecordingEvent.Screenflick.ScreenRecord.path + "movie.mov"

  func testScreenflickStartMapsCorrectly() {
    let event = FileWatcherEvent(FSEventStreamEventId(1234), FAKE_MOVIE_PATH,
      FSEventStreamEventFlags(kFSEventStreamEventFlagItemIsFile) | FSEventStreamEventFlags(kFSEventStreamEventFlagItemCreated)
    )

    let sut = RecordingEventMapper()
    let mapped: RecordingEvent = sut.map(event)

    switch mapped {
    case let .started(path, software):
      XCTAssertEqual(path, FAKE_MOVIE_PATH)
      XCTAssertEqual(software, RecordingSoftware.Screenflick)
    default:
      XCTFail("Event was type \"\(mapped)\"; was expecting \"started\"")
    }
  }

  func testScreenflickEndMapsCorrectly() {
    let event = FileWatcherEvent(FSEventStreamEventId(1234), FAKE_MOVIE_PATH,
      FSEventStreamEventFlags(kFSEventStreamEventFlagItemIsFile) | FSEventStreamEventFlags(kFSEventStreamEventFlagItemModified)
    )

    let sut = RecordingEventMapper()
    let mapped: RecordingEvent = sut.map(event)

    switch mapped {
    case .ended: break
      // Passes
    default:
      XCTFail("Event was type \"\(mapped)\"; was expecting \"ended\"")
    }
  }

  func testMapperIgnoresDirectoryEvents() {
    let directoryEvents = [
      FileWatcherEvent(FSEventStreamEventId(1234), RecordingEvent.Screenflick.ScreenRecord.path,
        FSEventStreamEventFlags(kFSEventStreamEventFlagItemIsDir) | FSEventStreamEventFlags(kFSEventStreamEventFlagItemRemoved)
      ),
      FileWatcherEvent(FSEventStreamEventId(1234), RecordingEvent.Screenflick.ScreenRecord.path,
        FSEventStreamEventFlags(kFSEventStreamEventFlagItemIsDir) | FSEventStreamEventFlags(kFSEventStreamEventFlagItemCreated)
      ),
      FileWatcherEvent(FSEventStreamEventId(1234), RecordingEvent.Screenflick.ScreenRecord.path,
        FSEventStreamEventFlags(kFSEventStreamEventFlagItemIsDir) | FSEventStreamEventFlags(kFSEventStreamEventFlagItemRenamed)
      )
    ]

    let sut = RecordingEventMapper()

    directoryEvents.forEach { event in
      let mapped: RecordingEvent = sut.map(event)

      switch mapped {
      case .ignored: break
        // Passes
      default:
        XCTFail("Event was type \"\(mapped)\"; was expecting \"ignored\"")
      }
    }
  }
}
