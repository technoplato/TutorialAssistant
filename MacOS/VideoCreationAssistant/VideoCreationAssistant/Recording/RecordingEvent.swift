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

  func requiresExport() -> Bool {
    switch self {
    case .Screenflick:
      return true
    default:
      return false
    }
  }
}

enum RecordingEvent {
  // The recording has just begun
  case started(_ path: String, _ software: RecordingSoftware)
  // The recording has ended
  case ended
  // The user has saved a finished video to a location on disk
  case finalized(_ path: String)
  case ignored
  case error(_ msg: String)

  enum Screenflick {
    struct ScreenRecord {
      static let path = "~/Library/Application Support/com.araeliumgroup.screenflick/Movies/".expandingTildeInPath
    }
  }
}
