//
// Created by Michael Lustig on 12/4/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import XCTest
@testable import VideoCreationAssistant

class YouTubePosterText: XCTestCase {

  func testVideosPostToYouTubeAndReturnUrls() {
    let expectation = XCTestExpectation(description: "Uploads clips to YouTube")

    YouTubePoster.post() { (result: [String]?, error) in
      XCTAssertNil(error)
      XCTAssertNotNil(result)
      XCTAssertEqual(result!.count, 2)
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 15)
  }
}