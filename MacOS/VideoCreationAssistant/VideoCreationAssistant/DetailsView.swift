////
////  DetailsView.swift
////  VideoCreationAssistant
////
////  Created by Michael Lustig on 10/29/19.
////  Copyright © 2019 lustig. All rights reserved.
////
//
//import SwiftUI
//
//class ImageLoader: ObservableObject {
//
//  @Published var data: Data?
//
//  init(urlString:String) {
//    guard let url = URL(string: urlString) else { return }
//    let task = URLSession.shared.dataTask(with: url) { data, response, error in
//      guard let data = data else { return }
//      DispatchQueue.main.async {
//        self.data = data
//      }
//    }
//    task.resume()
//  }
//}
//
//struct ImageView: View {
//  @ObservedObject var imageLoader:ImageLoader
//
//  init(withURL url:String) {
//    imageLoader = ImageLoader(urlString:url)
//  }
//
//  var body: some View {
//    VStack {
//      Image(nsImage: imageLoader.data != nil ? NSImage(data: imageLoader.data!)! : NSImage())
//        .resizable()
//        .aspectRatio(contentMode: .fit)
//    }
//  }
//}
//
//struct DetailsView: View {
//  @EnvironmentObject var recordingManager: RecordingManager
//
//  var body: some View {
//    Form {
////      Text("New Screenshot!").font(.headline)
////      Text("Add Details Below").font(.subheadline)
//      Section {
//        TextField("Title", text: $recordingManager.pending.title)
//        TextField("Description", text: $recordingManager.pending.description)
//        Text("Formatted Timestamp: \(TimeFormatter.formatDuration(recordingManager.pending.startTime))")
//      }
//      ImageView(withURL: recordingManager.pending.image)
//      Spacer()
//      Button("Save Timestamp") {
//        self.recordingManager.saveScreenshot()
//      }.disabled(self.recordingManager.pendingImage == "")
//    }.frame(minWidth: 500, maxWidth: .infinity, minHeight: 650, maxHeight: .infinity).padding()
//  }
//}
//
//struct DetailsView_Previews: PreviewProvider {
//  static var previews: some View {
//    DetailsView()
//  }
//}
//
//
