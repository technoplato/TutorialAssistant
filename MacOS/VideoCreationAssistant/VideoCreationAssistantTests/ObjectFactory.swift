//
//  File.swift
//  VideoCreationAssistantTests
//
//  Created by Michael Lustig on 11/22/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation

struct Factory {
  
  static func timestamp(start: Int, filePath: String) -> Timestamp {
    return Timestamp(
      seconds: start,
      formatted: String.random(),
      title: String.random(),
      description: String.random(),
      clipPath: filePath,
      youtubeId: String.random()
    )
  }
  
  static func timestamps(startTimes: [Int], filePath: String) -> [Timestamp] {
    return startTimes.map { start in
      return Factory.timestamp(start: start, filePath: filePath)
    }
  }
}
