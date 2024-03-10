//
//  AuthServiceTests.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 10/03/2024.
//

import XCTest
@testable import MyChat

//requires Firebase emulator to be running
final class AuthServiceTests: XCTestCase {
  private var authService: RealAuthenticationService!
  
  override func setUpWithError() throws {
    authService = RealAuthenticationService(appState: AppState())
  }
  
  override func tearDownWithError() throws {
    authService = nil
  }
  
  func test_EmailSignUp() async throws {
    let didSignUp = await authService.signUpWithEmailPassword(email: "test@mail.com", password: "test")
    
    XCTAssertTrue(didSignUp)
  }
  
  
  
  
}
