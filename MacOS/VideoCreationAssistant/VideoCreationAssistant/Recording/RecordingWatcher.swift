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

typealias RecordingEventCallback = (RecordingEvent) -> Void

class RecordingWatcher {
  
  static let shared = RecordingWatcher()
  let mapper = RecordingEventMapper()
  
  let filewatcher: FileWatcher
  var videoEventCallback: RecordingEventCallback?
  
  private init() {
    filewatcher = FileWatcher([
      "/",
//      quickTimeMovieCreatedPath,
//      quickTimeScreenRecordingCreatedPath,
      screenflickPath
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
    }
    
    filewatcher.start()
  }
  
  func stop() {
    self.filewatcher.stop()
    self.videoEventCallback = nil
  }
}


