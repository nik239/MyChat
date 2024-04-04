//
//  SignupViewTests.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 04/04/2024.
//

import XCTest
import ViewInspector
@testable import MyChat

final class SignupViewTests: XCTestCase {
  var sut: SignupView!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = SignupView()
  }
  
  @MainActor
  func test_signup() {
    //given
    let email = "some@email.com"
    let password = "testtest"
    let mockAuthService = MockedAuthService(expected: [.signUpWithEmailPassword(email: email, password: password)])
    let viewModel = AuthViewModel(authService: mockAuthService, appState: AppState())
    
    let exp = sut.inspection.inspect { view in
      //when
      let signupBtn = try view.find(button: "Sign up")
      //then
      XCTAssertTrue(signupBtn.isDisabled())
      //when
      viewModel.email = email
      viewModel.password = password
      viewModel.confirmPassword = password

    }
    
    let exp2 = sut.inspection.inspect(onReceive: viewModel.$password) { view in
      let signupBtn = try view.find(button: "Sign up")
      //then
      XCTAssertFalse(signupBtn.isDisabled())
      //when
      try signupBtn.tap()
      //then
      mockAuthService.verify()
    }
    
    ViewHosting.host(view: sut.environmentObject(viewModel))
    wait(for: [exp, exp2], timeout: 0.3)
  }
  
  @MainActor
  func test_switchFlow() {
    let viewModel = AuthViewModel(authService: StubAuthService(), appState: AppState())
    
    let exp = sut.inspection.inspect { view in
      //when
      let loginBtn = try view.find(button: "Log in")
      try loginBtn.tap()
      let flow = try view.actualView().viewModel.flow
      //then
      XCTAssertEqual(flow, .login)
    }
  }
}
