//
//  SetUsernameViewTests.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 09/04/2024.
//

import XCTest
import ViewInspector
@testable import MyChat

final class SetUsernameViewTests: XCTestCase {
//  @MainActor
//  func test_setUsername() {
//    //given
//    let sut = SetUsernameView()
//    let username = "testUser"
//    let mockAuthService = MockedAuthService(expected: [.setUsername(newName: username)])
//    let viewModel = UsernameViewModel(authService: mockAuthService, appState: AppState())
//    
//    let exp = sut.inspection.inspect { view in
//      let usernameField = try view.vStack().textField(1)
//      //when
//      try usernameField.setInput(username)
//      try usernameField.callOnCommit()
//    }
//    
//    let exp2 = sut.inspection.inspect(after: 0.5) { view in
//      //then
//      mockAuthService.verify()
//    }
//    
//    ViewHosting.host(view: sut.environmentObject(viewModel))
//    wait(for: [exp, exp2], timeout: 1)
//  }
  
  @MainActor
  func test_presentationLogic() {
    //when
    let sut = SetUsernameView()
    let viewModel = UsernameViewModel(authService: StubAuthService(), appState: AppState())
    viewModel.usernameState = .notSet
    
    let exp = sut.inspection.inspect { view in
      //then
      XCTAssertNoThrow(try view.find(viewWithTag: "prompt"))
      XCTAssertNoThrow(try view.find(viewWithTag: "username field"))
      XCTAssertThrowsError(try view.find(viewWithTag: "error"))
      XCTAssertThrowsError(try view.find(viewWithTag: "progress"))
      //when
      viewModel.usernameState = .updating
    }
    
    let exp2 = sut.inspection.inspect(onReceive: viewModel.$usernameState) { view in
      //then
      XCTAssertNoThrow(try view.find(viewWithTag: "progress"))
      XCTAssertThrowsError(try view.find(viewWithTag: "prompt"))
      XCTAssertThrowsError(try view.find(viewWithTag: "username field"))
      XCTAssertThrowsError(try view.find(viewWithTag: "error"))
      //when
      viewModel.usernameState = .error
    }
    
    let exp3 = sut.inspection.inspect(onReceive: viewModel.$usernameState) { view in
      XCTAssertNoThrow(try view.find(viewWithTag: "prompt"))
      XCTAssertNoThrow(try view.find(viewWithTag: "username field"))
      XCTAssertNoThrow(try view.find(viewWithTag: "error"))
      XCTAssertThrowsError(try view.find(viewWithTag: "progress"))
    }
    
    ViewHosting.host(view: sut.environmentObject(viewModel))
    wait(for: [exp, exp2, exp3], timeout: 1)
  }
}

