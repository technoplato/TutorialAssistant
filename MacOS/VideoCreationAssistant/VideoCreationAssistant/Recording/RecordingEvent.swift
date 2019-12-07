//
// Created by Michael Lustig on 12/5/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import Foundation

/*
 * List of currently supported recording software
 */
enum RecordingSoftware {
  case Unknown
//  case QuickTime
  case Screenflick
}

enum RecordingEvent {
  case started(_ path: String, _ software: RecordingSoftware)
  case ended
  case exported(_ path: String)
  case ignored
  case error(_ msg: String)

  enum Screenflick {
    struct ScreenRecord {
      static let path = "~/Library/Application Support/com.araeliumgroup.screenflick/Movies/".expandingTildeInPath
    }
  }
}
