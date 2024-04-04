//
//  AuthViewTests.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 17/03/2024.
//

import XCTest
import ViewInspector
import SwiftUI
@testable import MyChat

final class AuthViewTests: XCTestCase {
  var sut: AuthView<EmptyView>!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = AuthView() {}
  }
  
  func test_continueWithEmailPasswordBtn(){
    let exp = sut.inspection.inspect() { view in
      //when
      let btn = try view.find(button: "Continue with email and password")
      try btn.tap()
      //then
      XCTAssertTrue(try view.actualView().presentingCredentialsView)
    }
    ViewHosting.host(view: sut.inject(.stub(appState: AppState())))
    wait(for: [exp], timeout: 0.1)
  }
  
  func test_signInWithAppleButton() {
    let exp = sut.inspection.inspect() { view in
      XCTAssertNoThrow(try view.vStack().signInWithAppleButton(1))
    }
    ViewHosting.host(view: sut.inject(.stub(appState: AppState())))
    wait(for: [exp], timeout: 0.1)
  }
}
