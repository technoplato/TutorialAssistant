//
//  RecordingEnded.swift
//  SwiftUI Test
//
//  Created by Michael Lustig on 10/27/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import SwiftUI

struct RecordingEnded: View {
  
  @EnvironmentObject var recording: RecordingManager
  
  var body: some View {
    VStack {
    
      Button("I'm done recording") {
        self.recording.goToPosting()
      }
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
    
  }
  
  
}

struct RecordingEnded_Previews: PreviewProvider {
  static var previews: some View {
    RecordingEnded()
  }
}
//////        Text("Recording Ended!").frame(minWidth: 450, maxWidth: .infinity, minHeight: 270, maxHeight: .infinity).padding()
