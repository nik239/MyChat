//
//  ContentViewTests.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 04/04/2024.
//

import XCTest
import ViewInspector
@testable import MyChat

final class ContentViewTests: XCTestCase {
  func test_runningTests() {
    //when
    let sut = ContentView(container: .stub(appState: AppState()), isRunningTests: true)
    //then
    XCTAssertNoThrow(try sut.inspect().find(text: "Running unit tests"))
  }
  func test_notRunningTests() {
    //when
    let sut = ContentView(container: .stub(appState: AppState()), isRunningTests: false)
    //then
    XCTAssertThrowsError(try sut.inspect().find(text: "Running unit tests"))
  }
}
