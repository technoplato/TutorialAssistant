//
// Created by Michael Lustig on 12/11/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import XCTest

@testable import VideoCreationAssistant

class TimestampCreationTest: XCTestCase {

  func testTimestampIdIsAlphaNumeric() {
    let ts = Timestamp(duration: Duration(start: 0))

    XCTAssertTrue(ts.id.isAlphanumeric)
  }

}