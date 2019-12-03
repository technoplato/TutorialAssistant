//
// Created by Michael Lustig on 12/3/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import XCTest
import Foundation
@testable import VideoCreationAssistant

let TEST_DIR_PATH = "~/Desktop/DELETEMEIFEXISTS".expandingTildeInPath
let FILES_TO_CREATE = 3

class DirectoryUtilsTest: XCTestCase {

  override func setUp() {
    try? FileManager.default.removeItem(atPath: TEST_DIR_PATH)
    XCTAssertEqual(Directory.count(path: TEST_DIR_PATH), 0)
  }

  func testDirectoryCountWorks() {
    try! FileManager.default.createDirectory(atPath: TEST_DIR_PATH, withIntermediateDirectories: true)

    (0..<FILES_TO_CREATE).map {
      return "\(TEST_DIR_PATH)/\($0).txt"
    }.forEach { path in
      FileManager.default.createFile(atPath: path, contents: Data(base64Encoded: "foobarbaz"))
    }

    XCTAssertEqual(FILES_TO_CREATE, Directory.count(path: TEST_DIR_PATH))
  }

  func testDirectoryListWorks() {
    try! FileManager.default.createDirectory(atPath: TEST_DIR_PATH, withIntermediateDirectories: true)
    let paths = (0..<FILES_TO_CREATE).map {
      return "\(TEST_DIR_PATH)/number \($0).txt"
    }

    paths.forEach { path in
      FileManager.default.createFile(atPath: path, contents: Data(base64Encoded: "foobarbaz"))
    }

    XCTAssertEqual(Set(paths), Set(Directory.files(path: TEST_DIR_PATH)))
  }
}
