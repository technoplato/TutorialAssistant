//
// Created by Michael Lustig on 1/6/20.
// Copyright (c) 2020 lustig. All rights reserved.
//

import XCTest

@testable import VideoCreationAssistant

class UglyHacksTest: XCTestCase {
  func testPythonScriptRuns() {
    Shell.p("/usr/local/bin/python3 /Users/lustig/Desktop/Python/add_videos_to_playlist.py --id=PL3z1TiLmRFcyh9bMesOtNhyzXsg4dHhzM______ --videos=bnks9RAIh3U,eGKKYjn82VE,ymWfNPDO2_8")
  }
}
