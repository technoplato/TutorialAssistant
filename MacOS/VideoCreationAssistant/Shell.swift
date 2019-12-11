//
//  Shell.swift
//  VideoCreationAssistant
//
//  Created by Michael Lustig on 11/18/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation

class Shell {
  static func p(_ command: String) -> Void {
    let res = run(command)
    print(res)
  }

 static func run(_ command: String) -> String {
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c", command]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
    
    return output
  }

  static func appleScript(path: String) -> String {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = ["/usr/bin/osascript", path]

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

    return output
  }
  
}

