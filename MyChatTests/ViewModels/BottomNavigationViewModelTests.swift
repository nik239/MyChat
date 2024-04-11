//
//  BottomNavigationViewModelTests.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 03/04/2024.
//

import XCTest
@testable import MyChat

final class BottomNavigationViewModelTests: XCTestCase {
  var appState: AppState!
  var sut: BottomNavigationViewModel!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    appState = AppState()
    sut = BottomNavigationViewModel(appState: appState)
  }
  
  @MainActor 
  func test_subscribeToState() {
    XCTAssertEqual(sut.appStateSubs.count, 0)
    XCTAssertTrue(sut.showBottomNavigation)
    //when
    sut.subscribeToState()
    //then
    XCTAssertEqual(sut.appStateSubs.count, 2)
    //when
    appState.toggleBottomNavigation()
    //then
    XCTAssertFalse(sut.showBottomNavigation)
  }
  
  @MainActor
  func test_unsubscribeFromState() {
    //given
    sut.subscribeToState()
    //when
    sut.unsubscribeFromState()
    //then
    XCTAssertEqual(sut.appStateSubs.count, 0)
    //when
    appState.toggleBottomNavigation()
    //then
    XCTAssertTrue(sut.showBottomNavigation)
  }
}
