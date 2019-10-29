//
//  DetailsView.swift
//  VideoCreationAssistant
//
//  Created by Michael Lustig on 10/29/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import SwiftUI

class ImageLoader: ObservableObject {
  
  @Published var data: Data?
  
  init(urlString:String) {
    guard let url = URL(string: urlString) else { return }
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data else { return }
      DispatchQueue.main.async {
        self.data = data
      }
    }
    task.resume()
  }
}

struct ImageView: View {
  @ObservedObject var imageLoader:ImageLoader
  
  init(withURL url:String) {
    imageLoader = ImageLoader(urlString:url)
  }
  
  var body: some View {
    VStack {
      Image(nsImage: imageLoader.data != nil ? NSImage(data: imageLoader.data!)! : NSImage())
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width:200, height:200)
    }
  }
}

struct DetailsView: View {
  @EnvironmentObject var recordingManager: RecordingManager
  
  var body: some View {
    Form {
      TextField("Title", text: $recordingManager.pendingScreenshot.title)
      TextField("Description", text: $recordingManager.pendingScreenshot.description)
      Text("Formatted Timestamp: \(recordingManager.pendingScreenshot.formatted)")
      ImageView(withURL: recordingManager.pendingScreenshot.image)
      Spacer()
    }
    
  }
}

struct DetailsView_Previews: PreviewProvider {
  static var previews: some View {
    DetailsView()
  }
}


