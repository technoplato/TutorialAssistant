//
//  Devto.swift
//  VideoCreationAssistant
//
//  Created by Michael Lustig on 10/29/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation
import Alamofire

// TODO: Hide this
let API_KEY = "nHJfcB8ZKUgYmFbeNhMj4taK"
let headers: HTTPHeaders = [
  "api-key": API_KEY
]

let body = """
### Header 3 from Swift?

*Am I getting ... Swifty? ...?*
"""

struct Article: Encodable {
  let title: String
  let published: Bool
  let body_markdown: String
  let tags: [String]
  let series: String?
}

struct ArticleUpdate: Encodable {
  let title: String?
  let published: Bool?
  let body_markdown: String?
  let tags: [String]?
  let series: String?
}


struct ArticleResponse: Decodable {
  let id: Int
  let slug: String
  let url: String
}

class Devto {
  
  static func testPost() {
//    let article = Article(
//      title: "Test from swift",
//      published: true,
//      body_markdown: body,
//      tags: ["tinkering"],
//      series: nil
//    )
//
//    AF.request("https://dev.to/api/articles",
//               method: .post,
//               parameters: article,
//               encoder: JSONParameterEncoder.default,
//               headers: headers).responseDecodable(of: ArticleResponse.self) {response in debugPrint(response)}
  }
  
  static func updatePost() {
    let article = ArticleUpdate(
      title: "Test update from swift", published: nil, body_markdown: nil, tags: nil, series: nil
    )
    
    AF.request("https://dev.to/api/articles\(198043)",
      method: .put,
      parameters: article,
      encoder: JSONParameterEncoder.default,
      headers: headers).responseDecodable(of: ArticleResponse.self) {response in debugPrint(response)}
  }

}
