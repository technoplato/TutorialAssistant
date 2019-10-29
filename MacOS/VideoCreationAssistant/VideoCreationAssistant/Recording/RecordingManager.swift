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
}

class Screenshot: Timestamp, ObservableObject {
  @Published var image: String = ""
}

class RecordingManager: ObservableObject {
  
  private let stopwatch = Stopwatch()
  private let recordingWatcher = RecordingWatcher.shared
  private var monitor: ScreenshotMonitor?
  
  @Published var timestamps: [Timestamp] = []
  
  @Published var pendingScreenshot = Screenshot()
  
  @Published var state: RecordingState = .listening
  @Published var duration = Duration()
  
  @Published var seconds: Int = -1
  @Published var formatted: String = "00:00:00"
  
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
  
  func onRecordingStart() {
    self.state = .live
    self.stopwatch.start()
    self.listenForScreenshots()
  }
  
  func onRecordingEnd() {
    self.state = .ended
    self.stopwatch.stop()
    self.recordingWatcher.stop()
  }
  
  // MARK: Listeners
  
  private func listenForVideoRecordingStart() {
    recordingWatcher.videoEventCallback = { recordingEvent in
      switch recordingEvent {
        
      case .quickTimeScreenRecordStarted, .quickTimeScreenMovieStarted, .screenflickStart:
        self.onRecordingStart()
        
      case .quickTimeScreenRecordEnded, .quickTimeScreenMovieEnded, .screenflickEnd:
        self.onRecordingEnd()
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
