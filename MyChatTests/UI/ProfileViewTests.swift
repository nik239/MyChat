//
//  ProfileViewTests.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 03/04/2024.
//

import XCTest
import ViewInspector
@testable import MyChat

final class ProfileViewTests: XCTestCase {
  var sut: ProfileView!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = ProfileView()
  }
  
  func test_signOut() {
    let mockAuthService = MockedAuthService(expected: [.signOut])
    let container = DIContainer(viewModels: .mocked(authService: mockAuthService))
    let exp = sut.inspection.inspect { view in
      //when
      let signOutBtn = try view.find(button: "Sign out")
      try signOutBtn.tap()
      //then
      mockAuthService.verify()
    }
    
    ViewHosting.host(view: sut.inject(container))
    wait(for: [exp], timeout: 0.1)
  }
  
  @MainActor
  func test_deleteAccount() {
    let mockAuthService = MockedAuthService(expected: [.deleteAccount])
    let container = DIContainer(viewModels: .mocked(authService: mockAuthService))
    let exp = sut.inspection.inspect { view in
      //when
      let delBtn1 = try view.find(button: "Delete account?")
      try delBtn1.tap()
      //then
      XCTAssertTrue(try view.actualView().viewModel.showAlert)
    }
    
    ViewHosting.host(view: sut.inject(container))
    wait(for: [exp], timeout: 0.1)
  }
  
  func test_changeUsername() {
    let exp = sut.inspection.inspect { view in
      XCTAssertThrowsError(try view.find(ViewType.TextField.self))
      //when
      let changeBtn = try view.find(button: "Change username")
      try changeBtn.tap()
      //then
      XCTAssertNoThrow(try view.find(ViewType.TextField.self))
    }
  }
}
