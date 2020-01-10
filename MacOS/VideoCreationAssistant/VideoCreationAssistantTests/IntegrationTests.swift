//
// Created by Michael Lustig on 1/6/20.
// Copyright (c) 2020 lustig. All rights reserved.
//

import XCTest
import Foundation

@testable import VideoCreationAssistant

class IntegrationTests: XCTestCase {
  /**
   1) Extract clips from source
   2) Upload them to YouTube
   3) Create YouTube playlist
   4) Add videos to YouTube playlist
   */
  func testExtractClipsCreatePlaylistAndAddVideosToPlaylist() {
    let expectation = XCTestExpectation(description: "It just works")
    
    let rawVideoPath = "/Users/lustig/Desktop/DONTMOVEME/1234567.mp4"
    let clipPath = "/Users/lustig/Desktop/DONTMOVEME/CLIPS"
    try? FileManager.default.removeItem(atPath: clipPath)
    let youtube = YouTube()
    let extractor = ClipExtractor(
      rawVideoPath: rawVideoPath,
      clipExtractPath: clipPath,
      timestamps:
        Factory.timestamps(durations: [
          Duration(start: 12), Duration(start: 14)
        ])
    )
    
    let _ = extractor.extract()
    
    YouTubePoster(clipsPath: clipPath).post() { idsToURLs, error in
      print(idsToURLs)
      print(error)
      if let error = error {
        print(error)
        return
      }
      
      youtube.createPlaylist(title: "test title \(Date().description)") { playlist in
        let videoIds = idsToURLs!.map { (_, url) -> String in
          let url = URLComponents(string: url)!
          print("Is this the right ID for a YouTube video?", url.path)
          return url.path
        }
        
        youtube.addVideosToPlaylist(playlistId: playlist.id, videos: videoIds) { success in
          XCTAssertTrue(success)
          expectation.fulfill()
        }
      }
    }
    
    wait(for: [expectation], timeout: 200)
  }
}
