//
//  KeyForValue.swift
//  MyChat
//
//  Created by Nikita Ivanov on 19/03/2024.
//

import Foundation

extension Dictionary where Value: Equatable {
  /// O(n)
  func key(forValue value: Value) -> Key? {
    for (key, val) in self where val == value {
      return key
    }
    return nil
  }
}
