//
//  OA.swift
//  VideoCreationAssistant
//
//  Created by Michael Lustig on 12/13/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation
import OAuth2
import Alamofire
import PromiseKit


class OAuth {
  
  let oauth2: OAuth2CodeGrant
  
  init() {
    self.oauth2 = OAuth2CodeGrant(settings: [
      "client_id": "944530683864-es7ba0hoi4btp0jofdo2n61ta49i6h75.apps.googleusercontent.com",
      "authorize_uri": "https://accounts.google.com/o/oauth2/v2/auth",
      "token_uri": "https://www.googleapis.com/oauth2/v3/token",
      "redirect_uris": ["com.lustig.videocreationassistant:/oauth"],
      "scope": "https://www.googleapis.com/auth/youtube",
      "response_type": "code"
    ])
    
    
    
    oauth2.logger = OAuth2DebugLogger(.trace)
    let retrier = OAuthRetrier(oauth2: oauth2)
    Alamofire.SessionManager.default.retrier = retrier
    Alamofire.SessionManager.default.adapter = retrier
  }
  
  
  struct Snippet: Codable {
    let title: String
  }
  
  struct YouTubePlaylistItem: Codable {
    let id: String
    let etag: String
    let snippet: Snippet
  }
  
  struct YouTubePlaylist: Codable {
    let kind: String
    let items: [YouTubePlaylistItem]
  }
  
  func foo() {
    let url = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=id,snippet&playlistId=PL3z1TiLmRFcyh9bMesOtNhyzXsg4dHhzM")!
    
    
//              oauth2.authorize { (json, error) in
//                print(json)
//              }
    
    let first = Alamofire
        .request(url)
      .responseDecodable(YouTubePlaylist.self)
    let second = Alamofire
      .request(url)
      .responseDecodable(YouTubePlaylist.self)
    
    firstly {
      when(fulfilled: first, second)
    }.done { one, two in
      //…
      print(one)
      print(two)
    }.catch { error in
      //…
      print(error)
    }
    
    
//      Alamofire.request(url).response { response in
//        print(response)
//        if let data = response.data {
//          let playlist =  try! JSONDecoder().decode(YouTubePlaylist.self, from: data)
//
//          debugPrint("fuck \(playlist.items.first!.snippet.title)")
//          
//        }
//      }
  }
  
  
  
  // MARK: Rx
  
  func createYouTubePlaylist(title: String, description: String = "", callback: @escaping ((YouTubePlaylist) -> Void)) {
    
    //    let url = URL(string: "https://www.googleapis.com/youtube/v3/playlists?part=id,snippet")!
    //
    //    let params = [
    //      "title": title,
    //      "description": description
    //    ]
    //
    //    Alamofire.request(
    //      url.absoluteString,
    //      method: .post,
    //      parameters: ["snippet": params],
    //      encoding: JSONEncoding.default).validate().responseJSON { response in
    //        if let data = response.data {
    //          let playlist =  try! JSONDecoder().decode(YouTubePlaylist.self, from: data)
    //
    //          callback(playlist)
    //        }
    //    }
  }
  
  func addVideosToYouTubePlaylist(playlistId: String, videos: [String], callback: @escaping ((Bool)) -> Void) {
    
    oauth2.authorize { (json, error) in
      print(json)
      print(error)
    }
    
    //    let url = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=id,snippet")!
    //    var count = 0
    //    videos.forEach { video in
    //
    //      print(video)
    //
    //      let params = [
    //        "playlistId": playlistId,
    //        "resourceId": [
    //          "kind": "youtube#video",
    //          "videoId": video
    //        ]
    //        ] as [String : Any]
    //
    //      Alamofire.request(
    //        url.absoluteString,
    //        method: .post,
    //        parameters: ["snippet": params],
    //        encoding: JSONEncoding.default).responseJSON { response in
    //          print(response)
    //          if let error = response.error {
    //            print(error)
    //            callback(false)
    //          } else {
    //            count += 1
    //
    //            print("Count: \(count)")
    //            if (count == videos.count) {
    //              callback(true)
    //            }
    //          }
    //      }
    //
    //    }
  }
}
