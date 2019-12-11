//
// Created by Michael Lustig on 12/11/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import XCTest
@testable import VideoCreationAssistant

class StringExtensionsTest: XCTestCase {
  func testIsAlphanumeric() {
    let notAlphaNumeric = "8A75A034-853E-4495-9ECF-EA3D7D1B09A2"
    let isAlphaNumeric = "8A75A034853E44959ECFEA3D7D1B09A2"

    XCTAssertFalse(notAlphaNumeric.isAlphanumeric)
    XCTAssertTrue(isAlphaNumeric.isAlphanumeric)
  }
}