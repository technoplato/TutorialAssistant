//
//  PostingView.swift
//  SwiftUI Test
//
//  Created by Michael Lustig on 10/27/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import SwiftUI

struct PostingView: View {
  @EnvironmentObject var recording: RecordingManager
  
  var body: some View {
    return Form {
      Text("Post It").font(.title)
      Text("You have to manually post things right now, but that will be changed soon!")
        .font(.subheadline)
      
      Text("Enter a title for the overall video").bold()
      TextField("Enter title here", text: $recording.title)
      
      Text("Click to create Dev.to post").bold()
      Button("Create Post") {
        Devto.createPost(title: self.recording.title, body: self.recording.body) { response in
          print(response)
          self.recording.devtoId = response.id
          self.recording.devtoUrl = response.url
        }
      }
      
      if recording.devtoId != -1 {
        Text("Dev.to URL: \(self.recording.devtoUrl)")
      }
      
      CopyDevtoContent()
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct PostingView_Previews: PreviewProvider {
  static var previews: some View {
    PostingView()
  }
}
