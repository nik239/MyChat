//
//  StringError.swift
//  MyChat
//
//  Created by Nikita Ivanov on 13/03/2024.
//

import Foundation

extension String: LocalizedError {
  public var errorDescription: String? {
    return self
  }
}
