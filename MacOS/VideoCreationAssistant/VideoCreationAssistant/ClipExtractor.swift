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
  let clipExtractPath: String
  let timestamps: [Timestamp]

  init(rawVideoPath: String, clipExtractPath: String, timestamps: [Timestamp]) {
    self.fullVideoPath = rawVideoPath
    self.clipExtractPath = clipExtractPath
    self.timestamps = timestamps
  }

  func extract() -> [String: String] {
    var dict: [String: String] = [:]
    self.timestamps.enumerated().map { (index, ts) in
      var extractClip = "/usr/local/bin/ffmpeg -i \(fullVideoPath) -ss \(ts.duration.start)"
      if index < timestamps.count - 1 {
        extractClip.append(" -to \(self.timestamps[index + 1].duration.start)")
      }

      let clipPath = PathBuilder.build(timestamp: ts, path: clipExtractPath, fullVideoPath: fullVideoPath)
      try? FileManager.default.createDirectory(atPath: clipExtractPath, withIntermediateDirectories: true)
      extractClip.append(" -c copy \"\(clipPath)\"")
      _ = Shell.run(extractClip)

      dict[ts.id] = clipPath
    }

    return dict
  }
}
