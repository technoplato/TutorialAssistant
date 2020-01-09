//
// Created by Michael Lustig on 12/10/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import Foundation

enum YouTubeUrlParsingError: Error {
  case parsingError
}

struct YouTubePoster {
  
  let clipsPath: String
  let parser = ApplescriptYouTubeResultsParser()
  
  init(clipsPath: String) {
    self.clipsPath = clipsPath
  }

  /**
    Uploads videos to YouTube and returns a dicitonary of IDs mapped to YouTube URLs
   */
  func post(completion: @escaping (([String: String]?, String?) -> Void)) {
    do {
      let scriptPath = YouTubeUploadScriptBuilder().build(clipDir: clipsPath)
      let results = Shell.appleScript(path: scriptPath)
      let dict = try parser.parse(applescriptResults: results)
      completion(dict, nil)
    } catch {
      completion(nil, "Something went wrong with parsing...")
    }
  }
}

