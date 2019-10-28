//
//  StopWatch.swift
//  StopWatch
//

import Combine
import Foundation
import SwiftUI

typealias StopwatchEvent = (Int, String)
typealias StopwatchCallback = (StopwatchEvent) -> Void

class Stopwatch: ObservableObject {
  
  private var timer: Timer?
  var callback: StopwatchCallback?
  
  private var seconds: Int = 0
  private var stopWatchTime = "00:00:00"
  
  func start() {
    guard let _ = self.timer else {
      self.startTimer()
      return
    }
  }
  
  func stop() {
    self.timer?.invalidate()
    self.timer = nil
  }
  
  func reset() {
    self.stopWatchTime = "00:00:00"
    self.seconds = 0
    self.timer?.invalidate()
    self.timer = nil
  }
  
  private func startTimer() {
    self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true, block: {n in
      self.seconds += 1
      self.stopWatchTime = Stopwatch.convertCountToTimeString(interval: self.seconds)
      if (self.callback != nil) {
        self.callback?((self.seconds, self.stopWatchTime))
      }
    })
  }
}

extension Stopwatch {
  static func convertCountToTimeString(interval: Int) -> String {
    let seconds = interval % 60
    let minutes = (interval / 60) % 60
    let hours = (interval / 3600)
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
  }
}
