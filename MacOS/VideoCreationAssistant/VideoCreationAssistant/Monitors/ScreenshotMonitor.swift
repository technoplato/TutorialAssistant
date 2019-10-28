//
//  ScreenshotMonitor.swift
//  TutorialAssistant
//
//  Created by Michael Lustig on 9/29/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation

class ScreenshotMonitor {
  
  let callback: (URL) -> Void
  var handledURLs: [URL]
  var monitor: FolderContentMonitor?
  
  init(callback: @escaping (URL) -> Void) {
    self.callback = callback
    self.handledURLs = []
  }
  
  deinit {
    monitor?.stop()
  }
  
  func start() {
    guard let path = screenshotDirectoryURL?.path else {
      NSLog("Failed to get screenshot directory")
      return
    }
    
    monitor = FolderContentMonitor(pathsToWatch: [path], callback: handleFolderContentChange)
    monitor?.start()
  }
  
  func stop() {
    monitor?.stop()
  }
  
  func handleFolderContentChange(event: Event) {
    handleEvent(withURL: URL(fileURLWithPath: event.path))
  }
  
  func handleEvent(withURL url: URL) {
    if !handledURLs.contains(url) && recentScreenshotExists(at: url) {
      handledURLs.append(url)
      callback(url)
    }
  }
  
  func recentScreenshotExists(at url: URL) -> Bool {
    
    if url.lastPathComponent.hasPrefix(".") {
      return false // File is hidden
    }
    
    guard let attributes = try? FileManager.default
      .attributesOfItem(atPath: url.path) else {
        return false // Failed to get file attributes
    }
    
    guard let creationDate = attributes[.creationDate] as? Date else {
      return false // Failed to get creation date
    }
    
    if creationDate.timeIntervalSinceNow < -5 {
      return false // File is more than 5 seconds old - probably not a new screenshot
    }
    
    return true
  }
  
  var screenshotDirectoryURL: URL? {
    // Check for custom screenshot location chosen by user
    if let domain = UserDefaults.standard.persistentDomain(forName: "com.apple.screencapture"),
      let path = (domain["location"] as? NSString)?.standardizingPath {
      
      // Check that the chosen directory exists, otherwise screencapture will not use it
      var isDirectory: ObjCBool = false
      if FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) && isDirectory.boolValue {
        return URL(fileURLWithPath: path)
      }
    }
    
    // If a custom location is not defined (or invalid) return the default screenshot location (~/Desktop)
    return FileManager.default.urls(for: .desktopDirectory,
                                    in: .userDomainMask).first
  }
}
