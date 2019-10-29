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
    return VStack {
      
      ForEach(recording.timestamps, id: \.id) { timestamp in
        Text("\(timestamp.title) @ \(timestamp.formatted)")
      }
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct PostingView_Previews: PreviewProvider {
  static var previews: some View {
    PostingView()
  }
}
