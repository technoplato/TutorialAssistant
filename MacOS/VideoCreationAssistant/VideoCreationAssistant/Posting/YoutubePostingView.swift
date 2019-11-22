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
      
      Button("Extract Clips") {
        self.clips = ClipExtractor(
          rawVideoPath: self.recording.finalPath,
          timestamps: self.recording.timestamps
        ).extract()
      }
      
      Section {
        Picker(selection: $selectedPrivacy, label: Text("Privacy Status")) {
          ForEach(0 ..< privacyStatuses.count) {
            Text(self.privacyStatuses[$0])
          }
        }
      }
      
      Button("Upload Clips") {
        let ts = Timestamp()
        ts.clipPath = "~/Documents/test1.mp4".expandingTildeInPath
        ts.title = "Cool clip 1"
        ts.description = "Cool description 1"
        
        let ts2 = Timestamp()
        ts.clipPath = "~/Documents/22222.mp4".expandingTildeInPath
        ts.title = "Cool clip 2"
        ts.description = "Cool description 2"
        
        Shell.p("/usr/local/bin/python3 /Users/lustig/Development/Tools/ffmpeg/videos/upload.py --file \(ts.clipPath) --title '\(ts.title)' --description '\(ts.description)' --privacyStatus \(self.privacyStatuses[self.selectedPrivacy])")
        Shell.p("/usr/local/bin/python3 /Users/lustig/Development/Tools/ffmpeg/videos/upload.py --file \(ts2.clipPath) --title '\(ts2.title)' --description '\(ts2.description)' --privacyStatus \(self.privacyStatuses[self.selectedPrivacy])")
//        self.recording.timestamps.forEach { (ts) in
//          Shell.p("/usr/local/bin/python3 /Users/lustig/Development/Tools/ffmpeg/videos/upload.py --file \(ts.clipPath) --title \(ts.title) --description \(ts.description) --privacyStatus \(self.privacyStatuses[self.selectedPrivacy])")
//        }
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
