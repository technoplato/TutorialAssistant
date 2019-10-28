//
//  StopwatchView.swift
//  
//
//  Created by Michael Lustig on 10/10/19.
//

import SwiftUI


struct StopwatchView: View {
  
  @EnvironmentObject var recording: RecordingManager
  
  var body: some View {
    return VStack {
      Text(recording.duration.formatted)
  
      if (recording.duration.seconds != -1) {
        Text("Video ended, length is: \(recording.duration.formatted) (\(recording.duration.seconds))")
      }
    }
  }
}
