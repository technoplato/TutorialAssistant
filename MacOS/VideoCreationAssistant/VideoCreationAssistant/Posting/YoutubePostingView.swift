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
  @State var loading = false

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

      Button(self.loading ? "Uploading Clips, Please Don't Leave Page" : "Upload Clips") {
        self.loading = true
        YouTubePoster(clipsPath: self.recording.clipExtractPath).post() { videoIdToYouTubeIdDictionary, error  in
          if let error = error {
            self.error = error
            return
          }
          
          self.recording.videoToYouTubeIdDictionary = videoIdToYouTubeIdDictionary!
          self.youtube.createPlaylist(title: self.recording.title) { playlist in
            self.recording.playlistId = playlist.id
            
            let videoIds = videoIdToYouTubeIdDictionary!.map({ (_, youtubeId) -> String in
              return youtubeId
            })
            
            self.youtube.addVideosToPlaylist(playlistId: playlist.id, videos: videoIds) { success in
              self.loading = false
              self.error = ""
              print("success", success)
            }
          }
        }
      }.disabled(loading)
      
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
