//
//  RecordingWatcher.swift
//  Timer
//
//  Created by Michael Lustig on 10/9/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation
import FileWatcher

let quickTimeMovieCreatedPath = "~/Library/Containers/com.apple.QuickTimePlayerX/Data/Library/Autosave Information/Unsaved QuickTime Player Document.qtpxcomposition".expandingTildeInPath
let quickTimeScreenRecordingCreatedPath = "~/Library/ScreenRecordings/".expandingTildeInPath
let screenflickPath = "~/Library/Application Support/com.araeliumgroup.screenflick/Movies/".expandingTildeInPath

let screenflickExportPath = "~/Documents".expandingTildeInPath

typealias RecordingEventCallback = (RecordingEvent) -> Void

class RecordingWatcher {
  
  static let shared = RecordingWatcher()
  let mapper = RecordingEventMapper()
  
  let filewatcher: FileWatcher
  var videoEventCallback: RecordingEventCallback?
  
  private init() {
    filewatcher = FileWatcher([
//      "/"
//      quickTimeMovieCreatedPath,
//      quickTimeScreenRecordingCreatedPath,
      screenflickPath,
      screenflickExportPath
    ])
    
    filewatcher.callback = { event in
      
      if (self.videoEventCallback == nil) {
        print("videoEventCallback is nil, not active...")
        return
      }

      let mapped = self.mapper.map(event)

      switch mapped {
      case .ignored: break
      default:
        self.videoEventCallback!(mapped)
      }

//
//
//      if (mapped.i) {
//        return
//      }
//
//
//      let exported = event.path.starts(with: screenflickExportPath) && event.fileCreated
//      if (exported) {
//        print("Video was exported from Screenflick")
//      }
//
//      let started = event.fileCreated && !exported
//      let ended = event.fileRemoved || event.fileRenamed || event.fileModified
//
//      let ext = event.path.suffix(3).lowercased()
//      if (!recordingPathExtensions.contains(ext)) {
//        return
//      }
//
//      var software: RecordingSoftware = .Unknown
//
//      if event.path.starts(with: screenflickPath) {
//        software = .Screenflick
//      } else if event.path.starts(with: quickTimeMovieCreatedPath) || event.path.starts(with: quickTimeScreenRecordingCreatedPath) {
////        software = .QuickTime
//      }
//
//      if software == .Unknown {
//        self.videoEventCallback!(.error("Unknown software, please go complain to the developer."))
//      } else if ended {
//        self.videoEventCallback!(.ended)
//      } else if started {
//        self.videoEventCallback!(.started(event.path, software))
//      } else if exported {
//        self.videoEventCallback!(.exported(event.path))
//      }
    }
    
    filewatcher.start()
  }
  
  func stop() {
    self.filewatcher.stop()
    self.videoEventCallback = nil
  }
}


