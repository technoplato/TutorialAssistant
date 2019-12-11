//
// Created by Michael Lustig on 12/10/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import Foundation

enum YouTubeUrlParsingError: Error {
  case parsingError
}

class YouTubePoster {
  static func post(completion: @escaping (([String]?, String?) -> Void)) {

    let json = Shell.appleScript(path: "/Users/lustig/Desktop/youtube.scpt")
    print(json)
    let youtubeIds: [String] = try! json.split(separator: ",").map {
      $0.lowercased()
    }.filter {
      $0.contains("yout")
    }.map {
      guard let id: Substring = $0.split(separator: "/").last else {
        throw YouTubeUrlParsingError.parsingError
      }

      return id.lowercased()
    }

    completion(youtubeIds, nil)
  }
}

