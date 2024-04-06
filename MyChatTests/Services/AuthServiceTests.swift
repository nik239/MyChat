//
//  AuthServiceTests.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 10/03/2024.
//

import XCTest
import FirebaseAuth
import FirebaseFunctions
@testable import MyChat

//requires Firebase emulator to be restarted between runs
final class AuthServiceTests: XCTestCase {
  private var authService: RealAuthService!
  private var appState: AppState!
  
  static var didSetEmulator = false
    
  override func setUpWithError() throws {
    try super.setUpWithError()
    if !AuthServiceTests.didSetEmulator {
      Auth.auth().useEmulator(withHost:"127.0.0.1", port:9099)
      AuthServiceTests.didSetEmulator = true
    }
    appState = AppState()
    authService = RealAuthService(appState: appState)
  }
  
  override func tearDownWithError() throws {
    authService = nil
    appState = nil
    try Auth.auth().signOut()
  }
  
  @MainActor
  func test_EmailSignUpSuccess() async {
    //when
    authService.signUpWithEmailPassword(email: "test@mail.com", password: "testtest")
    await untilEqual(appState.userData.authState, to: .authenticated)
    //then
    let user = appState.userData.user
    let error = appState.userData.error
    XCTAssertNotNil(user)
    XCTAssertNil(error)
  }
  
  @MainActor
  func testEmailSignUpFailure() async {
    //when
    authService.signUpWithEmailPassword(email: "test1@mail.com", password: "test")
    await untilEqual(appState.userData.error, to: "The password must be 6 characters long or more.")
    //then
    let user = appState.userData.user
    let authState = appState.userData.authState
    XCTAssertNil(user)
    XCTAssertEqual(authState, .unauthenticated)
  }
  
  @MainActor
  func test_signOutSuccess() async {
    //given
    authService.signUpWithEmailPassword(email: "test2@mail.com", password: "testtest")
    await untilEqual(appState.userData.authState, to: .authenticated)
    //when
    authService.signOut()
    await untilEqual(appState.userData.authState, to: .unauthenticated)
    //then
    let user = appState.userData.user
    let error = appState.userData.error
    XCTAssertNil(user)
    XCTAssertNil(error)
  }
  
  @MainActor
  func test_deleteAccountSuccess() async {
    //given
    authService.signUpWithEmailPassword(email: "test3@mail.com", password: "testtest")
    await untilEqual(appState.userData.authState, to: .authenticated)
    //when
    authService.deleteAccount()
    await untilEqual(appState.userData.authState, to: .unauthenticated)
    //then
    let user = appState.userData.user
    let error = appState.userData.error
    XCTAssertNil(user)
    XCTAssertNil(error)
  }
  
  @MainActor
  func test_signInWithEmailPasswordFailure() async {
    //when
    authService.signInWithEmailPassword(email: "invalid@mail.com", password: "testtest")
    await untilEqual(appState.userData.error,
                     to: "There is no user record corresponding to this identifier. The user may have been deleted.")
    //then
    let user = appState.userData.user
    let authState = appState.userData.authState
    XCTAssertNil(user)
    XCTAssertEqual(authState, .unauthenticated)
  }
  
  @MainActor
  func test_signInWithEmailPasswordSuccess() async {
    //given
    let email = "test4@mail.com"
    let password = "testtest"
    authService.signUpWithEmailPassword(email: email, password: password)
    await untilEqual(appState.userData.authState, to: .authenticated)
    authService.signOut()
    await untilEqual(appState.userData.authState, to: .unauthenticated)
    //when
    authService.signInWithEmailPassword(email: email, password: password)
    await untilEqual(appState.userData.authState, to: .authenticated)
    //then
    let user = appState.userData.user
    let error = appState.userData.error
    XCTAssertNotNil(user)
    XCTAssertNil(error)
  }
}

extension AuthServiceTests {
  @MainActor
  func test_RequestFSupdate() async {
    //given
    Functions.functions().useEmulator(withHost: "http://127.0.0.1", port: 5001)
    authService.signUpWithEmailPassword(email: "test@mail.com", password: "testtest")
    authService.setDisplayName(newName: "donkey")
    await untilEqual(appState.userData.authState, to: .authenticated)
    let chat1 = Chat(members: ["donkey","horse","cow"])
    let chat2 = Chat(members: ["donkey","shrek","dragon"])
    let dbService = FireStoreService(appState: appState)
    try! await dbService.updateChat(chat: chat1)
    
    //try! await dbService.updateChat(chat: chat2)
    try? await Task.sleep(nanoseconds: UInt64(2_000_000_000))
    try! await authService.requestFSupdate(newName: "lord donkey")
  }
}
