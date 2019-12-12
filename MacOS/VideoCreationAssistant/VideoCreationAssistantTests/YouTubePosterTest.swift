//
// Created by Michael Lustig on 12/4/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import XCTest
@testable import VideoCreationAssistant
import Foundation

class YouTubePosterText: XCTestCase {

  func testVideosPostToYouTubeAndReturnUrls() {
    let expectation = XCTestExpectation(description: "Uploads clips to YouTube")

    YouTubePoster().post() { (result: [String: String]?, error: String?) in
      XCTAssertNil(error)
      XCTAssertNotNil(result)
      XCTAssertEqual(result!.count, 2)
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 15)
  }

  func testParsesApplescriptResultsProperly() {
    let sut = ApplescriptYouTubeResultsParser()
    let inputString = "title:2019 09 27 12 36 15, youtubeUrl:https://youtu.be/x4XcSh7lqkU, title:2019 09 27 12 38 23, youtubeUrl:https://youtu.be/SHrYN0KLtfM,"

    // TODO handle errors
    let idDict: [String: String] = try! sut.parse(applescriptResults: inputString)

    XCTAssertEqual(idDict.count, 2)
    XCTAssertEqual("https://youtu.be/x4XcSh7lqkU", idDict["2019 09 27 12 36 15"])
    XCTAssertEqual("https://youtu.be/SHrYN0KLtfM", idDict["2019 09 27 12 38 23"])
  }

  func testYouTubeUpdatesUpdatesVideo() {
    // TODO
  }

  func testCreateAppleScript() {

    print(FileManager.default.homeDirectoryForCurrentUser.absoluteURL.description)

    let filename = getDocumentsDirectory().appendingPathComponent("template.scpt")

    do {
      try "poop".write(to: filename, atomically: true, encoding: String.Encoding.utf8)
    } catch {
      // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
    }
  }

  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
}