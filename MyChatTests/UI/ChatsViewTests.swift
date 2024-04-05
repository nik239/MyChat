//
//  ChatsViewTests.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 17/03/2024.
//

import XCTest
import ViewInspector
@testable import MyChat

final class ChatsViewTests: XCTestCase {
  func test_ChaPreveiw() {
    let sut = ChatsView()
    let chatTable = ["1": Chat(members: [], name: "Sam")]
    let userData = AppState.UserData(chats: chatTable)
    let viewModel = ChatsViewModel(appState: AppState(userData: userData))
    let exp = sut.inspection.inspect() { view in
      XCTAssertNoThrow(try view.find(ChatPreview.self))
    }
    
    ViewHosting.host(view: sut.environmentObject(viewModel))
    wait(for: [exp], timeout: 0.1)
  }
}
