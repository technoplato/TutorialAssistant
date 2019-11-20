//
//  RecordingWatcher.swift
//  Timer
//
//  Created by Michael Lustig on 10/9/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation
import FileWatcher

extension String {
  // /Users/lustig/Library/Containers/com.lustig.SwiftUI-Test/Data/Library/Containers/com.apple.QuickTimePlayerX/Data/Library/Autosave Information/Unsaved QuickTime Player Document.qtpxcomposition
  // Does not work, see above file path
  var expandingTildeInPath: String {
    return self.replacingOccurrences(of: "~", with: FileManager.default.homeDirectoryForCurrentUser.path)
  }
}

let quickTimeMovieCreatedPath = "/Users/lustig/Library/Containers/com.apple.QuickTimePlayerX/Data/Library/Autosave Information/Unsaved QuickTime Player Document.qtpxcomposition"
let quickTimeScreenRecordingCreatedPath = "/Users/lustig/Library/ScreenRecordings/"
let screenflickPath = "/Users/lustig/Library/Application Support/com.araeliumgroup.screenflick/Movies/"
let screenflickExportPath = "~/Documents".expandingTildeInPath

let recordingPathExtensions = ["mov", "mp4"]

/*
 * List of currently supported recording software
 */
enum RecordingSoftware {
  case QuickTime
  case Screenflick
}

enum VideoEvent {
  case start(_ path: String, _ software: RecordingSoftware)
  case end
  case exported(_ path: String)
}

typealias VideoEventCallback = (VideoEvent) -> Void

class RecordingWatcher {
  
  static let shared = RecordingWatcher()
  
  let filewatcher: FileWatcher
  var videoEventCallback: VideoEventCallback?
  
  private init() {
    filewatcher = FileWatcher([
      quickTimeMovieCreatedPath,
      quickTimeScreenRecordingCreatedPath,
      screenflickPath,
      screenflickExportPath
    ])
    
    filewatcher.callback = { event in
      
      if (self.videoEventCallback == nil) {
        print("videoEventCallback is nil, not active...")
        return
      }
      
      let dirOperation = event.dirCreated || event.dirRemoved || event.dirRenamed || event.dirModified
      if (dirOperation) {
        return
      }
      
      let exported = event.path.starts(with: screenflickExportPath) && event.fileCreated
      if (exported) {
        print("Video was exported from Screenflick")
      }
      let started = event.fileCreated && !exported
      let ended = event.fileRemoved || event.fileRenamed || event.fileModified
      
      let ext = event.path.suffix(3).lowercased()
      if (!recordingPathExtensions.contains(ext)) {
        return
      }
      
      // TODO: better assignment here. What happens if not Screenflick or QuickTime?
      var software: RecordingSoftware = .QuickTime
      
      if event.path.starts(with: screenflickPath) {
        software = .Screenflick
      }
      
      if ended {
        self.videoEventCallback!(.end)
      } else if started {
        self.videoEventCallback!(.start(event.path, software))
      } else if exported {
        self.videoEventCallback!(.exported(event.path))
      }
    }
    
    filewatcher.start()
  }
  
  func stop() {
    self.filewatcher.stop()
    self.videoEventCallback = nil
  }
}


