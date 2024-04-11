//
//  UserNameViewModelTests.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 11/04/2024.
//

import XCTest
@testable import MyChat

final class UserNameViewModelTests: XCTestCase {
  var appState: AppState!
  var mockedAuthService: MockedAuthService!
  var sut: UsernameViewModel!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    mockedAuthService = MockedAuthService()
    appState = AppState()
    sut = UsernameViewModel(authService: mockedAuthService, appState: appState)
  }
  
  @MainActor
  func test_subscribeToState() {
    XCTAssertNil(sut.appStateSub)
    XCTAssertEqual(sut.error, "")
    //when
    sut.subscribeToState()
    //then
    XCTAssertNotNil(sut.appStateSub)
    //when
    appState.update(error: "test")
    //then
    XCTAssertEqual(sut.error, "test")
  }
  
  @MainActor
  func test_unsubscribeFromState() {
    //given
    sut.subscribeToState()
    //when
    sut.unsubscribeFromState()
    //then
    XCTAssertNil(sut.appStateSub)
    //when
    appState.update(error: "test")
    //then
    XCTAssertEqual(sut.error, "")
  }
  
  @MainActor
  func test_setUsernameFailure() {
    //given
    sut.userEntry = ""
    //when
    sut.setUsername()
    //then
    XCTAssertEqual(sut.usernameState, .error)
  }
  
  @MainActor
  func test_setUsernameSuccess() async {
    //given
    sut.userEntry = "test"
    //expected
    mockedAuthService.actions = .init(expected: [.setUsername(newName: "test")])
    //when
    sut.setUsername()
    //then
    XCTAssertEqual(sut.usernameState, .updating)
    try? await Task.sleep(nanoseconds: UInt64(1_000_000))
    mockedAuthService.verify()
  }
}
