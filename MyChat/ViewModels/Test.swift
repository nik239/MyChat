//
//  Test.swift
//  MyChat
//
//  Created by Nikita Ivanov on 21/03/2024.
//

import Foundation

protocol SomeProtocol: ObservableObject {
  func someFunc()
}

struct SomeStruct: SomeProtocol, ObservableObject {
  func someFunc() {}
}
