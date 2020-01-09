//
//  PostingView.swift
//  SwiftUI Test
//
//  Created by Michael Lustig on 10/27/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import SwiftUI

struct YoutubePostingView: View {
  let privacyStatuses = ["public", "private", "unlisted"]
  let youtube = YouTube()
  
  @EnvironmentObject var recording: RecordingManager
  
  @State var clips: [String] = []
  @State var selectedPrivacy = 0
  @State var error = ""

  var body: some View {

    return Form {
      Text("Post to YouTube").font(.title)
      
      Text(recording.finalPath)
      TextField("Name Your Playlist for YouTube", text: $recording.title)

      Section {
        Picker(selection: $selectedPrivacy, label: Text("Privacy Status")) {
          ForEach(0..<privacyStatuses.count) {
            Text(self.privacyStatuses[$0])
          }
        }
      }

      Button("Upload Clips") {
        YouTubePoster(clipsPath: self.recording.clipExtractPath).post() { idsToURls, error  in
          if let error = error {
            self.error = error
          }
          
          self.recording.youtubeURLs = idsToURls!
          self.youtube.createPlaylist(title: self.recording.title) { playlist in
            
          }
        }
      }
      
      if self.error != "" {
        Text(error)
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
