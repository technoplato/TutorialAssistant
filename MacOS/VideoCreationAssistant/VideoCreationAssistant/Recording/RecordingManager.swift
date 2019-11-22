//
//  Recording.swift
//  SwiftUI Test
//
//  Created by Michael Lustig on 10/27/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation
import Cocoa

class Duration: ObservableObject {
  @Published var seconds: Int = -1
  @Published var formatted: String = ""
}

enum RecordingState {
  case listening
  case live
  case ended
  case posting
}

class Timestamp {
  @Published var id = UUID()
  @Published var seconds = -1
  @Published var formatted = ""
  @Published var title = ""
  @Published var description = ""
  @Published var clipPath = ""
  @Published var youtubeId = ""
}

class Screenshot: Timestamp, ObservableObject {
  @Published var image: String = ""
}

class RecordingManager: ObservableObject {
  
  private let stopwatch = Stopwatch()
  private let recordingWatcher = RecordingWatcher.shared
  private var monitor: ScreenshotMonitor?
  
  @Published var tmpPath: String = ""
  @Published var finalPath: String = ""
  @Published var software: RecordingSoftware = .QuickTime
  @Published var timestamps: [Timestamp] = []
  
  @Published var pendingScreenshot = Screenshot()
  
  @Published var state: RecordingState = .listening
  @Published var duration = Duration()
  
  @Published var seconds: Int = -1
  @Published var formatted: String = "00:00:00"
  
  @Published var title: String = ""
  @Published var body: String = ""
  
  var devtoId: Int = -1
  var devtoUrl: String = ""
  
  init() {
    self.listenForVideoRecordingStart()
    self.listenToStopwatch()
    self.listenForImgurUpload()
  }
  
  func saveScreenshot() {
    timestamps.append(pendingScreenshot)
    pendingScreenshot = Screenshot()
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    appDelegate.hideScreenshotDetails()
  }
  
  func goToPosting() {
    state = .posting
  }
  
  // MARK: Recording Callbacks
  
  func onRecordingStart(_ path: String) {
    self.tmpPath = path
    self.state = .live
    self.stopwatch.start()
    self.listenForScreenshots()
  }
  
  func onRecordingEnd() {
    print("onRecordingEnd")
    self.state = .ended
    self.stopwatch.stop()
//    self.recordingWatcher.stop()
  }
  
  func onRecordingExported(_ path: String) {
    self.finalPath = path
  }
  
  // MARK: Listeners
  
  private func listenForVideoRecordingStart() {
    recordingWatcher.videoEventCallback = { recordingEvent in
      switch recordingEvent {
        
      case let .start(path, software):
        self.software = software
        self.onRecordingStart(path)
        
      case .end:
        self.onRecordingEnd()
        
      case let .exported(path):
        self.finalPath = path
      }
    }
  }
  
  private func listenToStopwatch() {
    stopwatch.callback =  { tick in
      let (seconds, formatted) = tick
      self.seconds = seconds
      self.formatted = formatted
    }
  }
  
  private func listenForScreenshots() {
    monitor = ScreenshotMonitor(callback: onScreenshot)
    monitor?.start()
  }
  
  func onScreenshot(uri: URL) {
    if (self.pendingScreenshot.seconds != -1 ) {
      // TODO Warn here if old timestamp wouldn't be saved...
      self.pendingScreenshot = Screenshot()
    }
    self.pendingScreenshot.seconds = self.seconds
    self.pendingScreenshot.formatted = self.formatted
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    appDelegate.promptScreenshotDetails()
    ImgurClient.shared.uploadImage(withURL: uri, isScreenshot: true)
  }
  
  private func listenForImgurUpload() {
    ImgurClient.shared.callback = { url in
      self.pendingScreenshot.image = url
    }
  }
  
  private func stopListeningForScreenshots() {
    monitor = nil
  }
}
