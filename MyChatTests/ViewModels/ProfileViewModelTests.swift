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
  func test_updateUserHandle() {
    //given
    let newHandle = "New Handle"
    sut.userHandle = newHandle
    //expected
    mockedAuthService.actions = .init(expected: [.changeUserHandle(newUserHandle: newHandle)])
    //when
    sut.updateUserHandle()
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
  func test_deleteAccount() {
    //expected
    mockedAuthService.actions = .init(expected: [.deleteAccount])
    //when
    sut.deleteAccount()
    //then
    mockedAuthService.verify()
  }
  
  @MainActor
  func test_subscribeToState() {
    //given
    var subscription = sut.appStateSub
    let userHandle = sut.userHandle
    //then
    XCTAssertNil(subscription)
    XCTAssertEqual(userHandle, "Unknown")
    //when
    sut.subscribeToState()
    subscription = sut.appStateSub
    //then
    XCTAssertNotNil(subscription)
  }
  
  @MainActor
  func test_unsubscribeFromState() {
    //given
    sut.subscribeToState()
    sut.unsubscribeFromState()
    let subscription = sut.appStateSub
    //then
    XCTAssertNil(subscription)
  }
}
