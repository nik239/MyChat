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
  
  func test_updateUserHandle() async {
    //given
    let newHandle = "New Handle"
    await MainActor.run {
      sut.userHandle = newHandle
    }
    //expected
    mockedAuthService.actions = .init(expected: [.changeUserHandle(newUserHandle: newHandle)])
    //when
    await sut.updateUserHandle()
    //then
    mockedAuthService.verify()
  }
  
  func test_signOut() async {
    //expected
    mockedAuthService.actions = .init(expected: [.signOut])
    //when
    await sut.signOut()
    //then
    mockedAuthService.verify()
  }
  
  func test_deleteAccount() async {
    //expected
    mockedAuthService.actions = .init(expected: [.deleteAccount])
    //when
    await sut.deleteAccount()
    //then
    mockedAuthService.verify()
  }
  
  func test_subscribeToState() async {
    //given
    var subscription = await sut.appStateSub
    let userHandle = await sut.userHandle
    //then
    XCTAssertNil(subscription)
    XCTAssertEqual(userHandle, "Unknown")
    //when
    await sut.subscribeToState()
    subscription = await sut.appStateSub
    //then
    XCTAssertNotNil(subscription)
  }
  
  func test_unsubscribeFromState() async {
    //given
    await sut.subscribeToState()
    await sut.unsubscribeFromState()
    let subscription = await sut.appStateSub
    //then
    XCTAssertNil(subscription)
  }
}
