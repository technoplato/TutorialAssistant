//
// Created by Michael Lustig on 12/10/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import SwiftUI

struct ClipExtractorView: View {

  @EnvironmentObject var recording: RecordingManager

  var body: some View {
    VStack {
      Button("Extract Clips") {
        self.recording.clipPaths = ClipExtractor(
          rawVideoPath: self.recording.finalPath,
          clipExtractPath: "~/Desktop/\(self.recording.id)/CLIPS".expandingTildeInPath,
          timestamps: self.recording.timestamps
        ).extract()
      }

      Button("Post Clips") {
        self.recording.goToPosting()
      }.disabled(self.recording.clipPaths.count == 0)
    }
  }
}












