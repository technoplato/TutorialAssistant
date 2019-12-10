//
// Created by Michael Lustig on 12/5/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import Foundation
import FileWatcher

let recordingPathExtensions = ["mov", "mp4"]

struct RecordingEventMapper {
  public func map(_ event: FileWatcherEvent) -> RecordingEvent {

    if shouldIgnore(event) {
      return .ignored
    } else if screenflick(event) {
      return handleScreenflick(event)
    } else if isVideo(event.path) {
      return .finalized(event.path)
    } else {
      return .ignored
    }
  }

  private func shouldIgnore(_ event: FileWatcherEvent) -> Bool {
    let wasDirectoryEvent = event.dirChange
    let notVideo = !isVideo(event.path)

    return wasDirectoryEvent || notVideo
  }

  private func isVideo(_ path: String) -> Bool {
    recordingPathExtensions.contains(path.suffix(3).lowercased())
  }

  private func screenflick(_ event: FileWatcherEvent) -> Bool {
    return event.path.starts(with: RecordingEvent.Screenflick.ScreenRecord.path)
  }

  private func handleScreenflick(_ event: FileWatcherEvent) -> RecordingEvent {
    if event.fileCreated {
      return .started(event.path, .Screenflick)
    } else if event.fileModified {
      return .ended
    } else if event.fileRemoved {
      return .ignored
    } else if event.fileRenamed {
      return .ignored
    }

    return .error("Error mapping Screenflick event...")
  }
}
