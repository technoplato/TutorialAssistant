//
//  DevtoContent.swift
//  VideoCreationAssistant
//
//  Created by Michael Lustig on 10/30/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import SwiftUI

struct CopyDevtoContent: View {
  
  @EnvironmentObject var recording: RecordingManager
  
  var body: some View {
    Button("Copy Dev.to Content to Clipboard and Open Dev.to Post") {
      NSPasteboard.general.clearContents()
      // TODO: Generate post from template in React project using Swift
      NSPasteboard.general.setString("Test Post", forType: .string)
      NSWorkspace.shared.open(URL(string: "\(self.recording.devtoUrl)/edit")!)
    }
  }
}

struct DevtoContent_Previews: PreviewProvider {
  static var previews: some View {
    CopyDevtoContent()
  }
}
