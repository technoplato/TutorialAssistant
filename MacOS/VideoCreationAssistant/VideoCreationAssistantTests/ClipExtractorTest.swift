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
  
  func testExtractsCorrectNumberOfClips() {
    let ts = Factory.timestamps(startTimes: [0, 5, 10], filePath: TEMP_VIDEO_CLIP_PATH)
    let extractor = ClipExtractor(rawVideoPath: TEST_VIDEO_PATH, timestamps: ts)
    let clips = extractor.extract()
  
    XCTAssertEqual(clips.count, ts.count)
    XCTAssertEqual(dirItemCount(path: TEMP_VIDEO_CLIP_PATH), ts.count)
    
  }
  
  private func dirItemCount(path: String) -> Int {
    guard let files = try? FileManager.default.contentsOfDirectory(atPath: path) else {
      return 0
    }
    
    return files.count
  }
}
