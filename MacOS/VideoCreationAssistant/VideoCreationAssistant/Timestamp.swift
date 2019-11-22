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
  @Published var seconds: Int
  @Published var formatted: String
  @Published var title: String
  @Published var description: String
  @Published var clipPath: String {
    didSet {
      if clipPath.suffix(1) != "/" {
        clipPath.append("/")
      }
    }
  }
  @Published var youtubeId: String
  var fullPath: String {
    return "\(clipPath)\(title)"
  }
  
  init(seconds: Int = -1,
       formatted: String = "",
       title: String = "",
       description: String = "",
       clipPath: String = "",
       youtubeId: String = "") {
    
    self.id = UUID()
    self.seconds = seconds
    self.formatted = formatted
    self.title = title
    self.description = description
    self.clipPath = clipPath
    self.youtubeId = youtubeId
  }
}
