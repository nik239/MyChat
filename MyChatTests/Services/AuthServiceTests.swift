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
  
  func test_EmailSignUp() async {
    //when
    let didSignUp = await authService.signUpWithEmailPassword(email: "test@mail.com", password: "testtest")
    //then
    XCTAssertTrue(didSignUp)
    XCTAssertEqual(appState.userData.authState, .authenticated)
    //when
    let didSignUpTwice = await authService.signUpWithEmailPassword(email: "test@mail.com", password: "testtest")
    //then
    XCTAssertFalse(didSignUpTwice)
  }
  
  func test_signOutSuccess() async {
    //given
    let didSignUp = await authService.signUpWithEmailPassword(email: "test2@mail.com", password: "testtest")
    //when
    authService.signOut()
    
    let expectation = XCTestExpectation(description: "Waiting for listener")
        
    let pollingInterval = 0.0001
    let timeout = 1.0
    
    let deadline = Date().addingTimeInterval(timeout)
    var isTimeout = false
    
    while appState.userData.authState != .unauthenticated && !isTimeout {
      await Task.sleep(UInt64(pollingInterval * 1_000_000_000)) // Convert seconds to nanoseconds
      if Date() > deadline {
        isTimeout = true
      }
    }
    
    if !isTimeout {
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: timeout)
    //then
    XCTAssertEqual(appState.userData.authState, .unauthenticated)
    XCTAssertNil(authService.appState.userData.user)
  }
  
  func test_deleteAccountSuccess() async {
    //given
    _ = await authService.signUpWithEmailPassword(email: "test3@mail.com", password: "testtest")
    //when
    let didDeleteAccount = await authService.deleteAccount()
    //then
    XCTAssertTrue(didDeleteAccount)
  }
  
  func test_signInWithEmailPasswordFailure() async {
    //when
    let didSignIn = await authService.signInWithEmailPassword(email: "invalid@mail.com", password: "testtest")
    //then
    XCTAssertFalse(didSignIn)
  }
  
  func test_signInWithEmailPasswordSuccess() async {
    //given
    _ = await authService.signUpWithEmailPassword(email: "test4@mail.com", password: "testtest")
    //when
    authService.signOut()
    let didSignIn = await authService.signInWithEmailPassword(email: "test4@mail.com", password: "testtest")
    //then
    XCTAssertTrue(didSignIn)
  }
}
