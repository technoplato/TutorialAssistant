//
//  BeforeRecording.swift
//  SwiftUI Test
//
//  Created by Michael Lustig on 10/27/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import SwiftUI

struct BeforeRecording: View {
  var body: some View {
    return VStack(alignment: .leading, spacing: 20) {
      Text("I'm waiting for you to start a recording").font(.title)
      Text("Once you start the recording, I'll automatically listen for screenshots and hotkey presses to tag events or start new chapters in your video.")
        .font(.subheadline)
      Spacer()
      Text("Keyboard Shortcuts")
        .font(.title)
      
      Text("⌘⇧C - New Chapter")
    }.frame(minWidth: 450, maxWidth: .infinity, minHeight: 270, maxHeight: .infinity).padding()
  }
}

struct BeforeRecording_Previews: PreviewProvider {
    static var previews: some View {
        BeforeRecording()
    }
}
