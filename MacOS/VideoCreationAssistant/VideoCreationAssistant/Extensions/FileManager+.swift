//
//  FileManager+.swift
//  VideoCreationAssistant
//
//  Created by Michael Lustig on 1/9/20.
//  Copyright © 2020 lustig. All rights reserved.
//

import Foundation

extension FileManager {
  static var desktopURL: URL {
    FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0]
  }
}
