//
// Created by Michael Lustig on 12/7/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import XCTest

@testable import VideoCreationAssistant

class RecordingSoftwareTest: XCTestCase {
  func testScreenflickRequiresExport() {
    let software: RecordingSoftware = .Screenflick

    XCTAssertTrue(software.requiresExport())
  }
}

