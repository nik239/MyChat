//
//  AuthViewModelTests.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 03/04/2024.
//

import XCTest
import FirebaseAuth
import Combine
@testable import MyChat

final class AuthViewModelTests: XCTestCase {
  var appState: AppState!
  var mockedAuthService: MockedAuthService!
  var sut: AuthViewModel!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    mockedAuthService = MockedAuthService()
    appState = AppState()
    sut = AuthViewModel(authService: mockedAuthService, appState: appState)
  }
  
  @MainActor
  func test_subscribeToState() async {
    await untilNotEqual(sut.appStateSubs, to: Set<AnyCancellable>())
    XCTAssertEqual(sut.authState, .unauthenticated)
    XCTAssertEqual(sut.errorMessage, "")
    //when
    appState.update(authState: .authenticated)
    appState.update(error: "Some error")
    //then
    XCTAssertEqual(sut.authState, .authenticated)
    XCTAssertEqual(sut.errorMessage, "Some error")
  }
  
  @MainActor
  func test_isValidPublisherLogin() async {
    await untilNotEqual(sut.appStateSubs, to: Set<AnyCancellable>())
    //when
    sut.flow = .login
    sut.email = "someemail"
    sut.password = "somepassword"
    //then
    XCTAssertTrue(sut.isValid)
    //when
    sut.flow = .login
    sut.email = ""
    sut.password = "somepassword"
    //then
    XCTAssertFalse(sut.isValid)
    //when
    sut.flow = .login
    sut.email = "someemail"
    sut.password = ""
    //then
    XCTAssertFalse(sut.isValid)
    //when
    sut.flow = .login
    sut.email = ""
    sut.password = ""
    //then
    XCTAssertFalse(sut.isValid)
  }
  
  @MainActor
  func test_isValidPublisherSignUp() async {
    await untilNotEqual(sut.appStateSubs, to: Set<AnyCancellable>())
    //when
    sut.flow = .signUp
    sut.email = "someemail"
    sut.password = "somepassword"
    sut.confirmPassword = "someotherpassword"
    //then
    XCTAssertTrue(sut.isValid)
    //when
    sut.flow = .signUp
    sut.email = "someemail"
    sut.password = "somepassword"
    sut.confirmPassword = ""
    //then
    XCTAssertFalse(sut.isValid)
    //when
    sut.flow = .signUp
    sut.email = ""
    sut.password = "somepassword"
    sut.confirmPassword = "somepassword"
    //then
    XCTAssertFalse(sut.isValid)
  }
  
  @MainActor
  func test_switchFlow() {
    //given
    sut.flow = .login
    //expected
    mockedAuthService.actions = .init(expected: [.clearError])
    //when
    sut.switchFlow()
    //then
    XCTAssertEqual(sut.flow, .signUp)
    mockedAuthService.verify()
    //given
    sut.flow = .signUp
    //expected
    mockedAuthService.actions = .init(expected: [.clearError])
    //when
    sut.switchFlow()
    //then
    XCTAssertEqual(sut.flow, .login)
    mockedAuthService.verify()
  }
  
  @MainActor
  func test_reset() {
    //given
    sut.email = "someEmal"
    sut.password = "somePassword"
    sut.confirmPassword = "somePassword"
    sut.flow = .signUp
    //when
    sut.reset()
    //then
    XCTAssertTrue(sut.email.isEmpty)
    XCTAssertTrue(sut.password.isEmpty)
    XCTAssertTrue(sut.confirmPassword.isEmpty)
    XCTAssertEqual(sut.flow, .login)
    //when
    sut.reset()
    //then
    XCTAssertEqual(sut.flow, .login)
  }
  
  @MainActor
  func test_signInWithEmailPassword() {
    //given
    let email = "someemail"
    let password = "somepasswrod"
    //expected
    mockedAuthService.actions = .init(expected: [.signInWithEmailPassword(email: email, password: password)])
    //when
    sut.email = email
    sut.password = password
    sut.signInWithEmailPassword()
    //then
    mockedAuthService.verify()
  }
  
  @MainActor
  func test_signUpWithEmailPassword() {
    //given
    let email = "someemail"
    let password = "somepasswrod"
    //expected
    mockedAuthService.actions = .init(expected: [.signUpWithEmailPassword(email: email, password: password)])
    //when
    sut.email = email
    sut.password = password
    sut.signUpWithEmailPassword()
    //then
    mockedAuthService.verify()
  }
}
