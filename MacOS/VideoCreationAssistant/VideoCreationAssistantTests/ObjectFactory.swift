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
    Timestamp(
        duration: Duration(start: 0),
        title: title,
        description: String.random()
    )
  }
  
  static func timestamp(duration: Duration) -> Timestamp {
    Timestamp(
      duration: duration,
      title: String.random(),
      description: String.random()
    )
  }
  
  static func timestamps(durations: [Duration]) -> [Timestamp] {
    durations.map { duration in
      Factory.timestamp(duration: duration)
    }
  }
}
