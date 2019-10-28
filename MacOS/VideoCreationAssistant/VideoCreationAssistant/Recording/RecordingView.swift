//
//  ContentView.swift
//  SwiftUI Test
//
//  Created by Michael Lustig on 10/26/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import SwiftUI

struct RecordingView: View {
  
  @EnvironmentObject var recording: RecordingManager
  
  var body: some View {
    return self.content()
  }
  
  private func content() -> AnyView {
    switch (recording.state) {
    case .listening:
      return AnyView(BeforeRecording())
    case .live, .ended:
      return AnyView(DuringRecording())
    case .posting:
      return AnyView(PostingView())
    
    }
  }
}

struct RecordingView_Preview: PreviewProvider {
  static var previews: some View {
    RecordingView()
  }
}
