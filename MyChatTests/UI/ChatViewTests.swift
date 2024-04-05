//
//  ChatViewTests.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 04/04/2024.
//

import XCTest
import ViewInspector
@testable import MyChat

final class ChatViewTests: XCTestCase {
  @MainActor
  func test_sendButton() {
    let sut = ChatView()
    let mockDBService = MockedDBService(expected: [.sendMessage(message: Message(author: "tester", content: "test"), toChatWithID: "test")])
    let userData = AppState.UserData.init(selectedChatID: "test")
    let viewModel = ChatViewModel(dbService: mockDBService, appState: AppState(userData: userData))
    
    let exp = sut.inspection.inspect() { view in
      //when
      let sendBtn = try view.find(viewWithTag: "send button")
      //then
      XCTAssertTrue(sendBtn.isDisabled())
      //when
      let textEditor = try view.find(ViewType.TextEditor.self)
      try textEditor.setInput("test")
    }
    
    let exp2 = sut.inspection.inspect(onReceive: viewModel.$userInput) { view in
      //when
      let sendBtn = try view.find(viewWithTag: "send button")
      //then
      XCTAssertFalse(sendBtn.isDisabled())
    }
    
    ViewHosting.host(view: sut.environmentObject(viewModel))
    wait(for: [exp, exp2], timeout: 0.2)
  }
}
