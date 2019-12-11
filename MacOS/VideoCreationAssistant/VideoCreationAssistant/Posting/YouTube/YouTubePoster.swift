//
// Created by Michael Lustig on 12/10/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import Foundation

class YouTubePoster {
  static func post(completion: @escaping (([String]?, String?) -> Void)) {

    let result = Shell.appleScript(path: "/Users/lustig/Desktop/youtube.scpt")
    let youtubeUrls = result.split(separator: ",").map {
      $0.lowercased()
    }.filter {
      $0.contains("yout")
    }

    completion(youtubeUrls, nil)
  }
}

