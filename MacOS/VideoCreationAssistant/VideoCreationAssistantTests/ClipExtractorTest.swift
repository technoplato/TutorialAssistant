//
//  ClipExtractorTest.swift
//  VideoCreationAssistantTests
//
//  Created by Michael Lustig on 11/22/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import XCTest

class ClipExtractorTest: XCTestCase {
  
  let TEST_VIDEO_PATH = "/Users/lustig/Documents/TESTS/TESTVIDEO.mp4"
  let TEMP_VIDEO_CLIP_PATH = "/Users/lustig/Documents/TESTS/TEMP/"
  
  override func setUp() {
    try? FileManager.default.removeItem(atPath: TEMP_VIDEO_CLIP_PATH)
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    try? FileManager.default.removeItem(atPath: TEMP_VIDEO_CLIP_PATH)
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  /*
  "/Users/lustig/Documents/TESTS/TEMP/OOTYDA5xqf XGdLsO1EBO.mp41bCtVLOiVP.mp4")
  "/Users/lustig/Documents/TESTS/TEMP/OOTYDA5xqf XGdLsO1EBO.mp4")

  */

  func testFileNameWithSpaceIsExtractedProperly() {
    let titleWithSpace = "\(String.random()) \(String.random()).mp4"
    let timestamp = Factory.timestamp(start: 0, filePath: "\(TEMP_VIDEO_CLIP_PATH)\(titleWithSpace)")
    let extractor = ClipExtractor(rawVideoPath: TEST_VIDEO_PATH, timestamps: [timestamp])

    let clips = extractor.extract()

    XCTAssertEqual(clips[0], timestamp.clipPath)
  }
  
  func testExtractsCorrectNumberOfClips() {
    let timestamps = Factory.timestamps(startTimes: [0, 5, 10], filePath: TEMP_VIDEO_CLIP_PATH)
    let extractor = ClipExtractor(rawVideoPath: TEST_VIDEO_PATH, timestamps: timestamps)

    let clips = extractor.extract()
  
    XCTAssertEqual(clips.count, timestamps.count)
    XCTAssertEqual(dirItemCount(path: TEMP_VIDEO_CLIP_PATH), timestamps.count)
  }
  
  private func dirItemCount(path: String) -> Int {
    guard let files = try? FileManager.default.contentsOfDirectory(atPath: path) else {
      return 0
    }
    
    return files.count
  }
}
