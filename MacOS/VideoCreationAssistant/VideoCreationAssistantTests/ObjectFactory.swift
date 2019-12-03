//
//  File.swift
//  VideoCreationAssistantTests
//
//  Created by Michael Lustig on 11/22/19.
//  Copyright © 2019 lustig. All rights reserved.
//

@testable import VideoCreationAssistant

struct Factory {

  static func timestamp(title: String) -> Timestamp {
    return Timestamp(
        duration: Duration(start: 0),
        title: title,
        description: String.random(),
        youtubeId: String.random()
    )
  }
  
  static func timestamp(duration: Duration) -> Timestamp {
    return Timestamp(
      duration: duration,
      title: String.random(),
      description: String.random(),
      youtubeId: String.random()
    )
  }
  
  static func timestamps(durations: [Duration]) -> [Timestamp] {
    return durations.map { duration in
      return Factory.timestamp(duration: duration)
    }
  }
}
