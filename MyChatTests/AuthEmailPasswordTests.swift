//
//  MyChatTests.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 11/02/2024.
//

import XCTest
@testable import MyChat

//boot up Firebase emulator before running
//final class AuthEmailPasswordTests: XCTestCase {
//  private var authModel: AuthViewModel!
//  
//  private let timeout: TimeInterval = 0.01
//  //private var expectation: XCTestExpectation!
//  
//  @MainActor
//  override func setUpWithError() throws {
//    try super.setUpWithError()
//    if authModel == nil {
//      authModel = AuthViewModel()
//    }
//    authModel.signOut()
//  }
//
//  
//  override func tearDownWithError() throws {
//    try super.tearDownWithError()
//  }
//  
//  @MainActor
//  func test_signup() async throws {
//    //given
//    authModel.email = "test@mail.com"
//    authModel.password = "testpassword"
//    authModel.confirmPassword = "testpassword"
//    
//    //when
//    let success = await authModel.signUpWithEmailPassword()
//    
//    //then
//    XCTAssertTrue(success)
//  }
//}
