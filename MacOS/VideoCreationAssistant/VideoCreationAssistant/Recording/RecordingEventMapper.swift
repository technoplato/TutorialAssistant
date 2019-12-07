//
// Created by Michael Lustig on 12/5/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import Foundation
import FileWatcher

let recordingPathExtensions = ["mov", "mp4"]

struct RecordingEventMapper {
  public func map(_ event: FileWatcherEvent) -> RecordingEvent {
    if event.dirChange {
      return .ignored
    }

    if recordingPathExtensions.contains(event.path.suffix(3).lowercased()) {
      return .ignored
    }

    if screenflick(event) {
      return handleScreenflick(event)
    }


    // started
    // ended
    // exported
    // error
    return .ignored
  }

  private func screenflick(_ event: FileWatcherEvent) -> Bool {
    return event.path.starts(with: RecordingEvent.Screenflick.ScreenRecord.path)
  }

  private func handleScreenflick(_ event: FileWatcherEvent) -> RecordingEvent {
    print(event.description)
    if event.fileCreated {
      return .started(RecordingEvent.Screenflick.ScreenRecord.path, .Screenflick)
    } else if event.fileRemoved {
      return .ended
    } else if event.fileRenamed {
      return .ended
    }

    return .error("Error mapping Screenflick event...")
  }
}
