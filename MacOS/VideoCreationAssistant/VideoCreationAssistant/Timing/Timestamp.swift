//
//  Timestamp.swift
//  VideoCreationAssistant
//
//  Created by Michael Lustig on 11/22/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation

class Timestamp {
  @Published var id: String
  @Published var duration: Duration
  @Published var title: String
  @Published var description: String
  
  init(duration: Duration,
       title: String = "",
       description: String = "") {

    var id = UUID().uuidString
    id.removeAll(where: { $0 == "-" })
    self.id = id
    self.duration = duration
    self.title = title
    self.description = description
  }
}

class Screenshot: Timestamp, ObservableObject {
  @Published var image: String = ""
}
