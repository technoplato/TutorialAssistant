//
// Created by Michael Lustig on 12/2/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

import Foundation

struct Directory {
  static func files(path: String, suffix: String = "") -> [String] {
    do {
      return try FileManager.default.contentsOfDirectory(atPath: path).filter {
        if (suffix == "") {
          return true
        } else {
          return $0.suffix(suffix.count) == suffix
        }
      }.map {
        "\(path)/\($0)"
      }
    } catch {
      return []
    }
  }

  static func count(path: String, suffix: String = "") -> Int {
    files(path: path, suffix: suffix).count
  }
}
