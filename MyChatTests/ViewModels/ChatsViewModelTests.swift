//
//  ChatsViewModelTests.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 05/04/2024.
//

import XCTest
@testable import MyChat
import Combine

final class ChatsViewModelTests: XCTestCase {
  var appState: AppState!
  var sut: ChatsViewModel!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    appState = AppState()
    sut = ChatsViewModel(appState: appState)
  }
  
  @MainActor
  func test_subscribeToState() {
    //given
    XCTAssertEqual(sut.appStateSubs.count, 0)
    XCTAssertNil(sut.chats)
    let chat = Chat(members: ["tester"])
    appState.update(chatAtID: "test", to: chat)
    //when
    sut.subscribeToState()
    //then
    XCTAssertEqual(sut.appStateSubs.count, 2)
    XCTAssertNotNil(sut.chats)
  }
  
  @MainActor
  func test_unsubscribeFromState() {
    //given
    sut.subscribeToState()
    //when
    sut.unsubscribeFromState()
    //then
    XCTAssertEqual(sut.appStateSubs.count, 0)
  }
  

  //Needs to be moved to Chat Tests
//  @MainActor
//  func test_isMoreRecent() {
//    //when
//    var chat1 = Chat(members: ["tester"])
//    var chat2 = Chat(members: ["tester"])
//    let message1 = Message(author: "tester", content: "test", date: .now)
//    let message2 = Message(author: "tester", content: "test", date: .now + 1)
//    chat1.messages = [message1]
//    chat2.messages = [message2]
//    //then
//    XCTAssertTrue(sut.isMoreRecent(chat2, then: chat1))
//    XCTAssertFalse(sut.isMoreRecent(chat1, then: chat2))
//  }
  
  @MainActor
  func test_messagePreview() {
    //given
    var chat = Chat(members: ["tester"])
    //when
    var preview = sut.messagePreview(chat: chat)
    //then
    XCTAssertEqual(preview, "")
    //when
    let message = Message(author: "tester", content: "test")
    chat.messages = [message]
    preview = sut.messagePreview(chat: chat)
    //then
    XCTAssertEqual(preview, "test")
  }
  
  @MainActor
  func test_lastMessageDate() {
    //when
    var chat = Chat(members: ["tester"])
    //then
    XCTAssertEqual(sut.lastMessageDate(chat: chat), "")
    //when
    let yesterday = Calendar.current.date(byAdding: DateComponents(hour: -24), to: .now)
    let message = Message(author: "tester", content: "test", date: yesterday!)
    chat.messages = [message]
    //then
    XCTAssertEqual(sut.lastMessageDate(chat: chat), "Yesterday")
    //when
    let twoDaysAgo = Calendar.current.date(byAdding: DateComponents(hour: -48), to: .now)
    let message2 = Message(author: "tester", content: "test", date: twoDaysAgo!)
    chat.messages = [message2]
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    let expected = formatter.string(from: twoDaysAgo!)
    //then
    XCTAssertEqual(sut.lastMessageDate(chat: chat), expected)
  }
  
  @MainActor
  func didTapOnChat() {
    //when
    var chat = Chat(members: ["tester"])
    sut.didTapOnChat(chat: chat)
    //then
    XCTAssertEqual(appState.userData.value.selectedChatID,
                   appState.userData.value.chats.key(forValue: chat))
  }
}
