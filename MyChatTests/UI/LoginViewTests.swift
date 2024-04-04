//
//  EmailLoginViewTests.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 04/04/2024.
//

import XCTest
import ViewInspector
@testable import MyChat

final class LoginViewTests: XCTestCase {
  var sut: LoginView!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = LoginView()
  }
  
  @MainActor
  func test_login() {
    //given
    let email = "some@email.com"
    let password = "testtest"
    let mockAuthService = MockedAuthService(expected: [.signInWithEmailPassword(email: email, password: password)])
    let viewModel = AuthViewModel(authService: mockAuthService, appState: AppState())
    
    let exp = sut.inspection.inspect { view in
      //when
      let loginBtn = try view.find(button: "Login")
      //then
      XCTAssertTrue(loginBtn.isDisabled())
      //when
      viewModel.email = email
      viewModel.password = password

    }
    
    let exp2 = sut.inspection.inspect(onReceive: viewModel.$password) { view in
      let loginBtn = try view.find(button: "Login")
      //then
      XCTAssertFalse(loginBtn.isDisabled())
      //when
      try loginBtn.tap()
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
      let signUpBtn = try view.find(button: "Sign up")
      try signUpBtn.tap()
      
      //then
      let flow = try view.actualView().viewModel.flow
      XCTAssertEqual(flow, .signUp)
    }
  }
}
