//
// Created by Michael Lustig on 12/10/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import Foundation

enum YouTubeUrlParsingError: Error {
  case parsingError
}

struct YouTubePoster {

  let parser = ApplescriptYouTubeResultsParser()

  func post(completion: @escaping (([String: String]?, String?) -> Void)) {

    // TODO use string interpolation to create Applescript
    let results = Shell.appleScript(path: "/Users/lustig/Desktop/youtube.scpt")
    do {
      let dict = try parser.parse(applescriptResults: results)
      completion(dict, nil)
    } catch {
      completion(nil, "Something went wrong with parsing...")
    }
  }
}

