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

struct Welcome: Codable {
  let snippet: Snippet
}

// MARK: - Snippet
struct Snippet: Codable {
  let title: String
}


class OA {
  
  let oauth2: OAuth2CodeGrant
  var loader: OAuth2DataLoader?
  
  init() {
    self.oauth2 = OAuth2CodeGrant(settings: [

      "client_id": "944530683864-es7ba0hoi4btp0jofdo2n61ta49i6h75.apps.googleusercontent.com",
//      "client_secret": "C-OaddROXscOyJKp4GeTzn6d",
      "authorize_uri": "https://accounts.google.com/o/oauth2/v2/auth",
      "token_uri": "https://www.googleapis.com/oauth2/v3/token",
//      "redirect_uris": ["urn:ietf:wg:oauth:2.0:oob"],
      "redirect_uris": ["com.lustig.videocreationassistant:/oauth"],
      "scope": "https://www.googleapis.com/auth/youtube",
      "response_type": "code"
      ])
    
    oauth2.logger = OAuth2DebugLogger(.trace)
    let retrier = OAuthRetrier(oauth2: oauth2)
    Alamofire.SessionManager.default.retrier = retrier
    Alamofire.SessionManager.default.adapter = retrier
  }
  
  func exchangeCodeForToken(_ pasted: String) {
    oauth2.exchangeCodeForToken(pasted)
  }
  
  func test() {
//    if let token = self.oauth2.accessToken {
//      print("token ==========>?>>>>>>> \(token)")
//    }
    self.oauth2.forgetTokens()
    self.oauth2.authorize {(json, error) in
      debugPrint(json)
      debugPrint(error)
    }
//    let url = URL(string: "https://www.googleapis.com/youtube/v3/playlists?part=id,snippet")!
////    let url = base.appendingPathComponent("user")
//
////    let snippet = Snippet(title: "how could you poop so long?")
////    let welcome = Welcome(snippet: snippet)
////    let j = try! JSONEncoder().encode(welcome)
////
////    let params = String(data: j, encoding: .utf8)!
////
//
//    let params = [
//
//        "title": "hello playlist from MacBook!"
//
//    ]
//
//    Alamofire.request(
//      url.absoluteString,
//      method: .post,
//      parameters: ["snippet": params],
//      encoding: JSONEncoding.default).validate().responseJSON { response in debugPrint(response) }

//    var req = oauth2.request(forURL: url)
//    req.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")


    
//    self.loader = OAuth2DataLoader(oauth2: oauth2)
//    loader!.perform(request: req) { response in
//      do {
//        let dict = try response.responseJSON()
//        DispatchQueue.main.async {
//          if let username = dict["name"] as? String {
//            print("Hello, \(username)")
//          }
//        }
//      }
//      catch let error {
//        DispatchQueue.main.async {
//          print(error)
//        }
//      }
//    }
    
  }
  
}
