//
//  Recording.swift
//  SwiftUI Test
//
//  Created by Michael Lustig on 10/27/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation

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

protocol Timestamp {
  var seconds: Int { get }
  var formatted: String { get }
  var title: String? {get}
  var description: String? {get}
}

struct Screenshot: Timestamp {
  
  let seconds: Int
  var formatted: String
  var title: String?
  var description: String?
  var image: String
  
  init(
    image: String,
    seconds: Int,
    formatted: String,
    title: String?,
    description: String?) {
    self.seconds = seconds
    self.formatted = formatted
    self.image = image
    self.title = title
    self.description = description
  }
}

class RecordingManager: ObservableObject {
  
  private let stopwatch = Stopwatch()
  private let recordingWatcher = RecordingWatcher.shared
  private var monitor: ScreenshotMonitor?
  private let timestamps: [Timestamp] = []

  @Published var state: RecordingState = .listening
  @Published var duration = Duration()
  
  @Published var seconds: Int = -1
  @Published var formatted: String = "00:00:00"
  
  private var screenshotSeconds = -1
  private var screenshotUrl: String = ""
  
  init() {
    self.listenForVideoRecordingStart()
    self.listenToStopwatch()
    self.listenForImgurUpload()
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
  
  private func listenForImgurUpload() {
    ImgurClient.shared.callback = {url in print(url)}
  }
  
  private func listenForScreenshots() {
    monitor = ScreenshotMonitor(callback: onScreenshot)
    monitor?.start()
  }
  
  private func stopListeningForScreenshots() {
    monitor = nil
  }
  
  func onScreenshot(uri: URL) {
    print(uri.absoluteString)
    ImgurClient.shared.uploadImage(withURL: uri, isScreenshot: true)
  }
  
}
