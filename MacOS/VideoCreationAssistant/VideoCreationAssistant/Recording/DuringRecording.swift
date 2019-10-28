//
//  DuringRecording.swift
//  
//
//  Created by Michael Lustig on 10/27/19.
//

import SwiftUI

struct DuringRecording: View {
  @EnvironmentObject var recording: RecordingManager
  
  var body: some View {
    
    return VStack {
      Text(recording.formatted)
      
      if (self.recording.state == .ended) {
        Text("Video ended, length is: \(recording.formatted) (\(recording.seconds)) seconds")
      }
      
      Button("Post It") {
        self.recording.goToPosting()
      }.disabled(self.recording.state != .ended)
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct DuringRecording_Previews: PreviewProvider {
  static var previews: some View {
    DuringRecording()
  }
}
