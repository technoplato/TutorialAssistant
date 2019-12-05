//
// Created by Michael Lustig on 12/4/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import XCTest
@testable import FileWatcher

class VideoEventMapperTest: XCTestCase {

  func testQuickTimeScreenRecordingEventMapsProperly() {
    let e = FileWatcherEvent(FSEventStreamEventId(1234), "/Users/lustig/Desktop/foo",
      FSEventStreamEventFlags(kFSEventStreamEventFlagItemIsFile) | FSEventStreamEventFlags(kFSEventStreamEventFlagItemCreated)
      )


  }

}