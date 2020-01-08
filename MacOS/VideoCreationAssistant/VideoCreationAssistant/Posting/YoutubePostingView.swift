//
//  PostingView.swift
//  SwiftUI Test
//
//  Created by Michael Lustig on 10/27/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import SwiftUI

struct YoutubePostingView: View {
  @EnvironmentObject var recording: RecordingManager
  @State var clips: [String] = []

  let privacyStatuses = ["public", "private", "unlisted"]
  @State var selectedPrivacy = 0

  var body: some View {

    return Form {
      Text("Post to YouTube").font(.title)

      if recording.software == .Screenflick && recording.finalPath == "" {
        Text("Please Export Video From Screenflick into the ~/Documents folder")
      }

      if recording.finalPath != "" {
        Text(recording.finalPath)
        TextField("Name Your Video for YouTube", text: $recording.title)
      }

      Section {
        Picker(selection: $selectedPrivacy, label: Text("Privacy Status")) {
          ForEach(0..<privacyStatuses.count) {
            Text(self.privacyStatuses[$0])
          }
        }
      }

      Button("Upload Clips") {
        
      }
    }

      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding()
  }
}

struct YoutubePostingView_Previews: PreviewProvider {
  static var previews: some View {
    YoutubePostingView()
  }
}
