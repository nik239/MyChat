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
  private var authService: RealAuthenticationService!
    
  override func setUpWithError() throws {
    Auth.auth().useEmulator(withHost:"localhost", port:9099)
    authService = RealAuthenticationService(appState: AppState())
  }
  
  override func tearDownWithError() throws {
    authService = nil
  }
  
  func test_EmailSignUp() async {
    //when
    let didSignUp = await authService.signUpWithEmailPassword(email: "test@mail.com", password: "testtest")
    
    //then
    XCTAssertTrue(didSignUp)
    XCTAssertEqual(authService.authState, .authenticated)
    
    //when
    let didSignUpTwice = await authService.signUpWithEmailPassword(email: "test@mail.com", password: "testtest")
    
    //then
    XCTAssertFalse(didSignUpTwice)
  }
  
  func test_signOutSuccess() async {
    //given
    let didSignUp = await authService.signUpWithEmailPassword(email: "test2@mail.com", password: "testtest")
    
    //when
    let didDeleteAccount = await authService.deleteAccount()
    
    //then
    XCTAssertTrue(didDeleteAccount)
  }
}
