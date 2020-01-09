//
//  YouTubeUploadScriptBuilder.swift
//  VideoCreationAssistant
//
//  Created by Michael Lustig on 1/8/20.
//  Copyright © 2020 lustig. All rights reserved.
//

import Foundation

struct YouTubeUploadScriptBuilder {
  
  func build(clipDir: String) -> String {
    let scriptPath = FileManager.desktopURL.appendingPathComponent("youtube-upload-template.scpt")
    try! YouTubeUploadTemplate().fill(clipDir: clipDir).write(to: scriptPath, atomically: true, encoding: String.Encoding.utf8)
    var wihthoutFileColonSlashSlash = scriptPath.absoluteString
    wihthoutFileColonSlashSlash.removeFirst(7)
    return wihthoutFileColonSlashSlash
  }
}

