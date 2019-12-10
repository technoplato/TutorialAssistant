//
//  Recording.swift
//  SwiftUI Test
//
//  Created by Michael Lustig on 10/27/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation
import Cocoa

enum RecordingState {
  case listening
  case live
  case ended
  case posting
}

class PendingInfo: ObservableObject {
  @Published var startTime: Int = -1
  @Published var image: String = ""
  @Published var title: String = ""
  @Published var description: String = ""
}

class RecordingManager: ObservableObject {

  private let stopwatch = Stopwatch()
  private let recordingWatcher = RecordingWatcher.shared
  private var monitor: ScreenshotMonitor?

  @Published var state: RecordingState = .listening
  @Published var software: RecordingSoftware = .Unknown

  @Published var tmpPath: String = ""
  @Published var finalPath: String = ""
  @Published var timestamps: [Timestamp] = []

  @Published var seconds: Int = -1 {
    didSet {
      formattedTime = TimeFormatter.formatDuration(seconds)
    }
  }
  @Published var formattedTime: String = "00:00:00"

  @Published var pending = PendingInfo()

  @Published var title: String = ""

  var devtoId: Int = -1
  var devtoUrl: String = ""

  init() {
    self.listenForVideoRecordingStart()
    self.listenToStopwatch()
    self.listenForImgurUpload()
  }

  func saveScreenshot(_ screenshot: Screenshot) {
    timestamps.append(screenshot)
    pending = PendingInfo()
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

  // MARK: Listeners

  private func listenForVideoRecordingStart() {
    recordingWatcher.videoEventCallback = { recordingEvent in
      switch recordingEvent {

      case let .started(path, software):
        self.software = software
        self.onRecordingStart(path)

      case .ended:
        self.onRecordingEnd()

      case let .exported(path):
        self.finalPath = path

      case let .error(msg):
        print("An unexpected recording software was used, figure out which one and add support for it.")
      case .ignored:
        print("Ignored")
      }
    }
  }

  private func listenToStopwatch() {
    stopwatch.callback = { tick in
      let (seconds, formatted) = tick
      self.seconds = seconds
      self.formattedTime = formatted
    }
  }

  private func listenForScreenshots() {
    monitor = ScreenshotMonitor(callback: onScreenshot)
    monitor?.start()
  }

  func onScreenshot(uri: URL) {
    if (self.pending.startTime != -1) {
      // TODO handle this more intelligently
      return
    }

    self.pending.startTime = self.seconds
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    appDelegate.promptScreenshotDetails()
    ImgurClient.shared.uploadImage(withURL: uri, isScreenshot: true)
  }

  private func listenForImgurUpload() {
    ImgurClient.shared.callback = { url in
      self.pending.image = url
    }
  }

  private func stopListeningForScreenshots() {
    monitor = nil
  }
}
