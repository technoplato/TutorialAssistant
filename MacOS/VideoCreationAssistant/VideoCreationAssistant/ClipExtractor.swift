//
//  ClipExtractor.swift
//  VideoCreationAssistant
//
//  Created by Michael Lustig on 11/20/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation

struct ClipExtractor {
  
  let rawVideoPath: String
  let timestamps: [Timestamp]
  
  init(rawVideoPath: String, timestamps: [Timestamp]) {
    self.rawVideoPath = rawVideoPath
    self.timestamps = timestamps
  }
  
  func extract() -> [String] {
    return self.timestamps.enumerated().map { (index, ts) in
      var extractClip = "/usr/local/bin/ffmpeg -i \(rawVideoPath) -ss \(ts.seconds)"
      if index < timestamps.count - 1 {
        extractClip.append(" -to \(self.timestamps[safeIndex: index + 1]!.seconds)")
      }
      let ext = rawVideoPath.suffix(3).lowercased()
      let clipPath = "~/Documents/\(ts.title).\(ext)".expandingTildeInPath
      extractClip.append(" -c copy \(clipPath)")
      Shell.run(extractClip)
      return clipPath
    }
  }
}
