//
// Created by Michael Lustig on 12/4/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import XCTest
@testable import VideoCreationAssistant
import Foundation

extension StringProtocol {
  func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
    var result: [Range<Index>] = []
    var startIndex = self.startIndex
    while startIndex < endIndex,
          let range = self[startIndex...].range(of: string, options: options) {
      result.append(range)
      startIndex = range.lowerBound < range.upperBound ? range.upperBound :
        index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
    }
    return result
  }
}

class YouTubePosterText: XCTestCase {

//  func testVideosPostToYouTubeAndReturnUrls() {
//    let expectation = XCTestExpectation(description: "Uploads clips to YouTube")
//
//    YouTubePoster.post() { (result: [String]?, error) in
//      XCTAssertNil(error)
//      XCTAssertNotNil(result)
//      XCTAssertEqual(result!.count, 2)
//      expectation.fulfill()
//    }
//
//    wait(for: [expectation], timeout: 15)
//  }


  func testRegex() {
    var idDict = [String: String]()

    let inputString = "title:2019 09 27 12 36 15, youtubeUrl:https://youtu.be/x4XcSh7lqkU, title:2019 09 27 12 38 23, youtubeUrl:https://youtu.be/SHrYN0KLtfM,".lowercased()

    let pattern = "title:([\\w\\d\\s]*), youtubeurl:(https://youtu.be/[\\w\\d]+),"
    let regex = try! NSRegularExpression(pattern: pattern, options: [])

    let nsrange = NSRange(inputString.startIndex..<inputString.endIndex, in: inputString)

    regex.enumerateMatches(in: inputString, options: [], range: nsrange) { (match, _, stop) in

      guard let match = match else {
        return
      }

      let idRange = Range(match.range(at: 1), in: inputString)
      let urlRange = Range(match.range(at: 2), in: inputString)

      let id = inputString[idRange!].lowercased()
      let url = inputString[urlRange!].lowercased()

      idDict[id] = url
    }

//    inputString.ranges(of: "title:([\\w\\d\\s]*), youtubeUrl:(https://youtu.be/[\\w\\d]+),", options: .regularExpression).forEach {
//      let ytinfo = inputString[$0].split(separator: ",").map {$0.lowercased()}
//      let id = ytinfo[0]
//      let url = ytinfo[1]
//      print(id)
//      print(url)
//      idDict[id] = url
//    }

    XCTAssertEqual(idDict.count, 2)
    XCTAssertEqual("https://youtu.be/x4XcSh7lqkU".lowercased(), idDict["2019 09 27 12 36 15"])
    XCTAssertEqual("https://youtu.be/SHrYN0KLtfM".lowercased(), idDict["2019 09 27 12 38 23"])
  }
}