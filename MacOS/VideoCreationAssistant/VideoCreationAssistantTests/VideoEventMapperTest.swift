//
// Created by Michael Lustig on 12/4/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import XCTest
@testable import FileWatcher
@testable import VideoCreationAssistant

class VideoEventMapperTest: XCTestCase {

  func testScreenflickStartMapsCorrectly() {
    let event = FileWatcherEvent(FSEventStreamEventId(1234), RecordingEvent.Screenflick.ScreenRecord.path,
      FSEventStreamEventFlags(kFSEventStreamEventFlagItemIsFile) | FSEventStreamEventFlags(kFSEventStreamEventFlagItemCreated)
    )

    let sut = RecordingEventMapper()
    let mapped: RecordingEvent = sut.map(event)

    switch mapped {
    case let .started(path, software):
      XCTAssertEqual(path, RecordingEvent.Screenflick.ScreenRecord.path)
      XCTAssertEqual(software, RecordingSoftware.Screenflick)
    default:
      XCTFail("Event was type \"\(mapped)\"; was expecting \"started\"")
    }
  }

  func testScreenflickEndMapsCorrectly() {
    let event = FileWatcherEvent(FSEventStreamEventId(1234), RecordingEvent.Screenflick.ScreenRecord.path,
      FSEventStreamEventFlags(kFSEventStreamEventFlagItemIsFile) | FSEventStreamEventFlags(kFSEventStreamEventFlagItemRemoved)
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
}