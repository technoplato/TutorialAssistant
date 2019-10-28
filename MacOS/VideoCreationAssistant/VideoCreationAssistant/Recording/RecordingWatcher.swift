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
let screenflickPath = "/Users/lustig/Application Support/com.araeliumgroup.screenflick/Movies/Screenflick Movie.sfmovie/Camera.mov"

enum VideoEvent {
  case quickTimeScreenRecordStarted
  case quickTimeScreenRecordEnded
  case quickTimeScreenMovieStarted
  case quickTimeScreenMovieEnded
  case screenflickStart
  case screenflickEnd
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
      screenflickPath
    ])
    
    filewatcher.callback = { event in
      
      if (self.videoEventCallback == nil) {
        return
      }
      
      let started = event.fileCreated
      let ended = event.fileRemoved || event.fileRenamed || event.fileModified
      
      if (!started && !ended) {
        return;
      }
      
      let path = event.path
      
      let ext = path.suffix(3)
      if (!["mov"].contains(ext)) {
        return
      }
      
      let qtScreen = path.starts(with: quickTimeScreenRecordingCreatedPath)
      let qtMovie = path.starts(with: quickTimeMovieCreatedPath)
      let screenflick = path.starts(with: screenflickPath)
      
      if (ended) {
        
        print(event.fileRemoved)
        print(event.fileRenamed)
        print(event.fileModified)
        
        if (qtScreen) {
          self.videoEventCallback!(.quickTimeScreenRecordEnded)
        } else if (qtMovie) {
          self.videoEventCallback!(.quickTimeScreenMovieEnded)
        } else if (screenflick) {
          self.videoEventCallback!(.screenflickEnd)
        }
        
      } else if (started) {
        
        if (qtScreen) {
          self.videoEventCallback!(.quickTimeScreenRecordStarted)
        } else if (qtMovie) {
          self.videoEventCallback!(.quickTimeScreenMovieStarted)
        } else if (screenflick) {
          self.videoEventCallback!(.screenflickStart)
        }
      }
    }
    
    filewatcher.start()
  }
  
  func stop() {
    self.filewatcher.stop()
    self.videoEventCallback = nil
  }
}


