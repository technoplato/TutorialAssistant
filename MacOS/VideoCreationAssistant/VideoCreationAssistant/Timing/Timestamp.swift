//
//  Timestamp.swift
//  VideoCreationAssistant
//
//  Created by Michael Lustig on 11/22/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation

class Timestamp {
  @Published var id: UUID
  @Published var duration: Duration
  @Published var title: String
  @Published var description: String

  @Published var youtubeId: String
  
  init(duration: Duration,
       title: String = "",
       description: String = "",
       youtubeId: String = "") {

    self.id = UUID()
    self.duration = duration
    self.title = title
    self.description = description
    self.youtubeId = youtubeId
  }
}

class Screenshot: Timestamp, ObservableObject {
  @Published var image: String = ""
}