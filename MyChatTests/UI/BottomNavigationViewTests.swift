//
//  BottomNavigationViewTests.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 03/04/2024.
//

import XCTest
import ViewInspector
@testable import MyChat

final class BottomNavigationViewTests: XCTestCase {
  func test_initialTabVisibility() {
    let sut = BottomNavigationView()
    let exp = sut.inspection.inspect { view in
      XCTAssertNoThrow(try view.tabView().view(ChatsView.self, 0).tabItem())
      XCTAssertNoThrow(try view.tabView().view(ProfileView.self, 1).tabItem())
    }
    
    ViewHosting.host(view: sut.inject(.stub(appState: AppState())))
    wait(for: [exp], timeout: 0.1)
  }
}
