//
//  ClipExtractor.swift
//  VideoCreationAssistant
//
//  Created by Michael Lustig on 11/20/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation

struct ClipExtractor {
  
  let fullVideoPath: String
  let timestamps: [Timestamp]
  
  init(rawVideoPath: String, timestamps: [Timestamp]) {
    self.fullVideoPath = rawVideoPath
    self.timestamps = timestamps
  }
  
  func extract() -> [String] {
    return self.timestamps.enumerated().map { (index, ts) in
      var extractClip = "/usr/local/bin/ffmpeg -i \(fullVideoPath) -ss \(ts.seconds)"
      if index < timestamps.count - 1 {
        extractClip.append(" -to \(self.timestamps[index + 1].seconds)")
      }

      let clipPath = "\(ts.clipPath).".expandingTildeInPath
      Shell.run("mkdir -p \(ts.clipPath)")
      extractClip.append(" -c copy \(clipPath)")
      Shell.run(extractClip)
      return clipPath
    }
  }
}
