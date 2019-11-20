//
//  ArrayExtensions.swift
//  VideoCreationAssistant
//
//  Created by Michael Lustig on 11/20/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation

extension Array {
  //  public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
  //    guard index >= 0, index < endIndex else {
  //      return defaultValue()
  //    }
  //
  //    return self[index]
  //  }
  
  /**
   * Usage:
   *
   * let arr = ["a", "b"]
   * let notThere = arr[safeIndex: 2]
   * precondition(notThere == nil)
   *
   */
  public subscript(safeIndex index: Int) -> Element? {
    guard index >= 0, index < endIndex else {
      return nil
    }
  
    
    return self[index]
  }
}
