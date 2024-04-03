//
//  AuthServiceTests.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 10/03/2024.
//

import XCTest
import FirebaseAuth
@testable import MyChat

//requires Firebase emulator to be restarted before each run
final class AuthServiceTests: XCTestCase {
  private var authService: RealAuthService!
  private var appState: AppState!
  
  static var didSetEmulator = false
    
  override func setUpWithError() throws {
    try super.setUpWithError()
    if !AuthServiceTests.didSetEmulator {
      Auth.auth().useEmulator(withHost:"localhost", port:9099)
      AuthServiceTests.didSetEmulator = true
    }
    appState = AppState()
    authService = RealAuthService(appState: appState)
  }
  
  override func tearDownWithError() throws {
    authService = nil
  }
  
  func test_EmailSignUpSuccess() async {
    //when
    authService.signUpWithEmailPassword(email: "test@mail.com", password: "testtest")
    //then
    await untilEqual(await appState.userData.authState, to: .authenticated)
    let error = await appState.userData.error
    XCTAssertEqual(error, "")
  }
  
  func testEmailSignUpFailure() async {
    //when
    authService.signUpWithEmailPassword(email: "test1@mail.com", password: "test")
    //then
    await untilEqual(await appState.userData.error, to: "The password must be 6 characters long or more.")
    let authState = await appState.userData.authState
    XCTAssertEqual(authState, .unauthenticated)
  }
  
  func test_signOutSuccess() async {
    //given
    authService.signUpWithEmailPassword(email: "test2@mail.com", password: "testtest")
    await untilEqual(await appState.userData.authState, to: .authenticated)
    //when
    authService.signOut()
    //then
    await untilEqual(await appState.userData.authState, to: .unauthenticated)
    let user = await authService.appState.userData.user
    XCTAssertNil(user)
  }
  
  func test_signOutFailure() async {
    
  }
//
//  func test_deleteAccountSuccess() async {
//    //given
//    _ = await authService.signUpWithEmailPassword(email: "test3@mail.com", password: "testtest")
//    //when
//    let didDeleteAccount = await authService.deleteAccount()
//    //then
//    XCTAssertTrue(didDeleteAccount)
//  }
//  
//  func test_signInWithEmailPasswordFailure() async {
//    //when
//    let didSignIn = await authService.signInWithEmailPassword(email: "invalid@mail.com", password: "testtest")
//    //then
//    XCTAssertFalse(didSignIn)
//  }
//  
//  func test_signInWithEmailPasswordSuccess() async {
//    //given
//    _ = await authService.signUpWithEmailPassword(email: "test4@mail.com", password: "testtest")
//    //when
//    authService.signOut()
//    let didSignIn = await authService.signInWithEmailPassword(email: "test4@mail.com", password: "testtest")
//    //then
//    XCTAssertTrue(didSignIn)
//  }
}
