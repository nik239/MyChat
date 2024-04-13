//
//  ProfileViewModel.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 28/03/2024.
//

import XCTest
import FirebaseAuth
@testable import MyChat

final class ProfileViewModelTests: XCTestCase {
  var appState: AppState!
  var mockedAuthService: MockedAuthService!
  var sut: ProfileViewModel!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    mockedAuthService = MockedAuthService()
    appState = AppState()
    sut = ProfileViewModel(authService: mockedAuthService, appState: appState)
  }
  
  @MainActor
  func test_updateUserHandle() async {
    //given
    let newHandle = "New Handle"
    sut.username = newHandle
    //expected
    mockedAuthService.actions = .init(expected: [.setUsername(newName: newHandle)])
    //when
    sut.setUserName()
    try? await Task.sleep(nanoseconds: UInt64(1_000_000))
    //then
    mockedAuthService.verify()
  }
  
  @MainActor
  func test_signOut() {
    //expected
    mockedAuthService.actions = .init(expected: [.signOut])
    //when
    sut.signOut()
    //then
    mockedAuthService.verify()
  }
  
  @MainActor
  func test_deleteAccount() async {
    //expected
    mockedAuthService.actions = .init(expected: [.deleteAccount])
    //when
    sut.deleteAccount()
    try? await Task.sleep(nanoseconds: UInt64(1_000_000))
    //then
    mockedAuthService.verify()
  }
  
  @MainActor
  func test_subscribeToState() {
    //given
    XCTAssertEqual(sut.appStateSubs.count, 0)
    //when
    sut.subscribeToState()
    //then
    XCTAssertEqual(sut.appStateSubs.count, 2)
  }
  
  @MainActor
  func test_unsubscribeFromState() {
    //given
    sut.subscribeToState()
    sut.unsubscribeFromState()
    //then
    XCTAssertEqual(sut.appStateSubs.count, 0)
  }
}
