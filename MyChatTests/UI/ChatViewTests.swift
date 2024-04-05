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
    let msgContent = "test"
    let mockDBService = MockedDBService(expected: [.sendMessage(message: Message(author: "tester", content: msgContent), toChatWithID: "test")])
    let userData = AppState.UserData.init(selectedChatID: "test")
    let viewModel = ChatViewModel(dbService: mockDBService, appState: AppState(userData: userData))
    
    let exp = sut.inspection.inspect() { view in
      //when
      let sendBtn = try view.find(viewWithTag: "send button")
      //then
      XCTAssertTrue(sendBtn.isDisabled())
      //when
      let textEditor = try view.find(ViewType.TextEditor.self)
      try textEditor.setInput(msgContent)
    }
    
    let exp2 = sut.inspection.inspect(onReceive: viewModel.$userInput) { view in
      //when
      let sendBtn = try view.vStack().hStack(2).button(1)
      //then
      XCTAssertFalse(sendBtn.isDisabled())
      //when
      try sendBtn.tap()
      //then
     // mockDBService.verify()
    }
    
    let exp3 = sut.inspection.inspect(after: 0.3) { view in
      mockDBService.verify()
    }
    
    ViewHosting.host(view: sut.environmentObject(viewModel))
    wait(for: [exp, exp2, exp3], timeout: 0.5)
  }
}
