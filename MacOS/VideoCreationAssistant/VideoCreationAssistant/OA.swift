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
  var loader: OAuth2DataLoader?
  
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
  
  func createYouTubePlaylist(title: String, description: String = "", callback: @escaping ((YouTubePlaylist) -> Void)) {
    let url = URL(string: "https://www.googleapis.com/youtube/v3/playlists?part=id,snippet")!

    let params = [
        "title": title,
        "description": description
    ]

    Alamofire.request(
      url.absoluteString,
      method: .post,
      parameters: ["snippet": params],
      encoding: JSONEncoding.default).validate().responseJSON { response in
        if let data = response.data {
          let playlist =  try! JSONDecoder().decode(YouTubePlaylist.self, from: data)
          
          callback(playlist)
          
        }
    }
  }
}

struct YouTubePlaylist: Codable {
  let id: String
}
