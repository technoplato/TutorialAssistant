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
      Text("Post Your Clips").font(.title)

      Button("Click to clips to Dev.to") {
//        Devto.createPost(title: self.recording.title, body: self.recording.body) { response in
//          print(response)
//          self.recording.devtoId = response.id
//          self.recording.devtoUrl = response.url
//        }
      }
      
      if recording.devtoId != -1 {
        Text("Dev.to URL: \(self.recording.devtoUrl)")
      }
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct PostingView_Previews: PreviewProvider {
  static var previews: some View {
    PostingView()
  }
}
