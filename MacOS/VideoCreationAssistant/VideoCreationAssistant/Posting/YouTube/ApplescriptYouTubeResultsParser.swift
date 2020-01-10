//
// Created by Michael Lustig on 12/12/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import Foundation

struct ApplescriptYouTubeResultsParser {

  private let pattern: String = "title:([\\w\\d\\s]*), youtubeUrl:(https://youtu.be/[\\w\\d]+),"

  /**
   Returns dictionary of video IDs to YouTube IDs
   */
  func parse(applescriptResults results: String) throws -> [String:String] {
    var idDict = [String: String]()
    let regex = try NSRegularExpression(pattern: pattern, options: [])
    let nsrange = NSRange(results.startIndex..<results.endIndex, in: results)

    regex.enumerateMatches(in: results, options: [], range: nsrange) { (match, _, stop) in

      guard let match = match else {
        return
      }

      let idRange = Range(match.range(at: 1), in: results)
      let urlRange = Range(match.range(at: 2), in: results)

      let id = results[idRange!].description
      let youtubeUrl = results[urlRange!].description
      
      var path = URLComponents(string: youtubeUrl)!.path
      path.removeAll { c -> Bool in
        c == "/"
      }
      
      let youtubeId = path

      idDict[id] = youtubeId
    }

    return idDict
  }
}
