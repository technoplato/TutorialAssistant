//
//  StringExtensions.swift
//  VideoCreationAssistant
//
//  Created by Michael Lustig on 11/22/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation

extension String {
  static func random(length: Int = 10) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
  }
  
  var expandingTildeInPath: String {
    self.replacingOccurrences(of: "~", with: FileManager.default.homeDirectoryForCurrentUser.path)
  }

  var isAlphanumeric: Bool {
    !isEmpty && range(of: "^[:alnum:]+$", options: .regularExpression) != nil
  }
}
