//
//  ClipExtractorTest.swift
//  VideoCreationAssistantTests
//
//  Created by Michael Lustig on 11/22/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import XCTest
@testable import VideoCreationAssistant

class ClipExtractorTest: XCTestCase {
  
  let TEST_VIDEO_PATH = "/Users/lustig/Documents/TESTS/TESTVIDEO.mp4"
  let TEMP_VIDEO_CLIP_PATH = "/Users/lustig/Documents/TESTS/TEMP"
  
  override func setUp() {
    try? FileManager.default.removeItem(atPath: TEMP_VIDEO_CLIP_PATH)
  }
  
  override func tearDown() {
    try? FileManager.default.removeItem(atPath: TEMP_VIDEO_CLIP_PATH)
  }

//  func testFileNameWithSpaceIsExtractedProperly() {
//    let titleWithSpace = "\(String.random()) \(String.random())"
//    let timestamp = Factory.timestamp(title: titleWithSpace)
//    let fullPath = "\(TEMP_VIDEO_CLIP_PATH)/\(timestamp.title).\(TEST_VIDEO_PATH.suffix(3))"
//
//    let extractor = ClipExtractor(
//      rawVideoPath: TEST_VIDEO_PATH,
//      clipExtractPath: TEMP_VIDEO_CLIP_PATH,
//      timestamps: [timestamp])
//
//    let clips = extractor.extract()
//
//    XCTAssertEqual(clips[timestamp.id], fullPath)
//  }
  
  func testExtractsCorrectNumberOfClips() {
    let timestamps = Factory.timestamps(
      durations: [
        Duration(start: 0),
        Duration(start: 3),
        Duration(start: 6)
      ]
    )

    let extractor = ClipExtractor(
      rawVideoPath: TEST_VIDEO_PATH,
      clipExtractPath: TEMP_VIDEO_CLIP_PATH,
      timestamps: timestamps)

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
