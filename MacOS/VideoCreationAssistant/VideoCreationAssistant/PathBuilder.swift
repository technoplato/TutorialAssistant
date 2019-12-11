//
// Created by Michael Lustig on 12/2/19.
// Copyright (c) 2019 lustig. All rights reserved.
//

struct PathBuilder {

  static func build(timestamp: Timestamp, path: String, fullVideoPath: String) -> String {
    "\(path)/\(timestamp.id).\(fullVideoPath.suffix(3))"
  }
}