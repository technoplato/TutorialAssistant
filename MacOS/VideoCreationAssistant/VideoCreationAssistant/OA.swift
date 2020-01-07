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
  
  func createYouTubePlaylist(title: String, description: String = "", callback: @escaping ((YouTubePlaylist) -> Void)) {
    //    oauth2.authorize { (json, error) in
    //      print(json)
    //      print(error)
    //    }
    //
    //    return
    
    let url = URL(string: "https://www.googleapis.com/youtube/v3/playlists?part=id,snippet")!
    
    let snippet = ["snippet":  [
      "title": title,
      "description": description
      ]]
    
    Alamofire.request(
      url.absoluteString,
      method: .post,
      parameters: snippet,
      encoding: JSONEncoding.default).validate().responseJSON { response in
        if let data = response.data {
          let playlist =  try! JSONDecoder().decode(YouTubePlaylist.self, from: data)
          
          callback(playlist)
        }
    }
  }
  
  func addVideosToYouTubePlaylist(playlistId: String, videos: [String], callback: @escaping ((Bool)) -> Void) {
    //    oauth2.authorize { (json, error) in
    //      print(json)
    //      print(error)
    //    }
    //
    //    return
    
    let url = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=id,snippet")!
    
    let paramsArray = videos.map { id in
      ["snippet": [
        "playlistId": playlistId,
        "resourceId": [
          "kind": "youtube#video",
          "videoId": id
        ]
        ]]
    }
    
    let dispatchQueue = DispatchQueue.global(qos: .background)
    let semaphore = DispatchSemaphore(value: 0)
    
    dispatchQueue.async {
      paramsArray.forEach { params in
        Alamofire
          .request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
          .validate()
          .responseJSON { response in
            if let data = response.data {
              let item =  try! JSONDecoder().decode(YouTubePlaylistItem.self, from: data)
              print(item)
            } else {
              callback(false)
            }
            
            // Signal that one request has completed so the next can fire off
            // (Required because YouTube API appears picky about simulataneous requests)
            semaphore.signal()
        }
        
        semaphore.wait()
      }
      
      callback(true)
    }
  }
}
