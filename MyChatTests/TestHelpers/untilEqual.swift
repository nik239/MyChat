//
//  AwaitEquals.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 02/04/2024.
//

import XCTest

extension XCTestCase {
  func untilEqual<T:Equatable>(_ actual: @autoclosure () async -> T,
                               to expected: T,
                               timeout: Double = 1.0,
                               pollingInterval: Double = 0.0001,
                               file: StaticString = #file,
                               line: UInt = #line) async {
    
    let expectation = XCTestExpectation(description: "untilEqual in \(#file), on line \(#line)")
    
    let deadline = Date().addingTimeInterval(timeout)
    var isTimeout = false
    
    while await actual() != expected && !isTimeout {
      try? await Task.sleep(nanoseconds: UInt64(pollingInterval * 1_000_000_000))
      if Date() > deadline {
        isTimeout = true
      }
    }
    
    if !isTimeout {
      expectation.fulfill()
    }
    
    await fulfillment(of: [expectation], timeout: timeout)
  }
  
  func untilNotEqual<T:Equatable>(_ actual: @autoclosure () async -> T,
                               to expected: T,
                               timeout: Double = 1.0,
                               pollingInterval: Double = 0.0001,
                               file: StaticString = #file,
                               line: UInt = #line) async {
    
    let expectation = XCTestExpectation(description: "untilEqual in \(#file), on line \(#line)")
    
    let deadline = Date().addingTimeInterval(timeout)
    var isTimeout = false
    
    while await actual() == expected && !isTimeout {
      try? await Task.sleep(nanoseconds: UInt64(pollingInterval * 1_000_000_000))
      if Date() > deadline {
        isTimeout = true
      }
    }
    
    if !isTimeout {
      expectation.fulfill()
    }
    
    await fulfillment(of: [expectation], timeout: timeout)
  }
}
