//
//  ChatsViewModelTests.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 04/04/2024.
//

import XCTest
@testable import MyChat
import Combine

final class ChatViewModelTests: XCTestCase {
  var appState: AppState!
  var mockDBService: MockedDBService!
  var sut: ChatViewModel!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    mockDBService = MockedDBService()
    appState = AppState()
    sut = ChatViewModel(dbService: mockDBService, appState: appState)
  }
  
  @MainActor
  func test_subscribeToState() {
    //given
    let testName = "test name"
    let testID = "testID"
    XCTAssertEqual(sut.appStateSubs.count, 0)
    appState.update(chatAtID: testID, to: Chat(members: ["tester"], name: testName))
    //then
    XCTAssertNil(sut.chatName)
    XCTAssertNil(sut.messages)
    //when
    sut.subscribeToState(selectedChatId: testID)
    //then
    XCTAssertEqual(sut.appStateSubs.count, 2)
    XCTAssertEqual(sut.chatName, testName)
    //when
    let messages = [Message(author: "tester", content: "test")]
    appState.update(messagesAtID: testID, to: messages)
    //then
    XCTAssertEqual(sut.messages, messages)
  }
  
  @MainActor
  func test_unsubscribeFromState() {
    //given
    sut.subscribeToState(selectedChatId: "test")
    XCTAssertEqual(sut.appStateSubs.count, 2)
    //when
    sut.unsubscribeFromState()
    //then
    XCTAssertEqual(sut.appStateSubs.count, 0)
  }
  
  @MainActor
  func test_sendMessage() async {
    //given
    let content = "test message"
    let testID = "testID"
    sut.userInput = content
    appState.update(selectedChatID: testID)
    sut.subscribeToState(selectedChatId: testID)
    //expected
    mockDBService.actions = .init(expected:[.sendMessage(message: Message(author: "tester", content: content), toChatWithID: testID)])
    //when
    sut.sendMessage()
    try! await Task.sleep(nanoseconds: UInt64(1_000_000))
    //then
    mockDBService.verify()
  }
  
  @MainActor
  func test_isAuthorSelf() {
    //when
    let message = Message(author: "tester", content: "test")
    //then
    XCTAssertFalse(sut.isAuthorSelf(message: message))
  }
  
  @MainActor
  func test_calculateTextHeight() {
    //when
    sut.userInput = ""
    sut.calculateTextHeight()
    //then
    XCTAssertEqual(sut.editorHeight, 20)
    //when
    sut.userInput = "veryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryverylong"
    sut.calculateTextHeight()
    //then
    XCTAssertEqual(sut.editorHeight, 100)
  }
  
  @MainActor
  func test_backUpUserInput() {
    //given
    let testInput = "this is a test"
    let id = "test"
    var chat = Chat(members: ["tester"])
    appState.update(chatAtID: id, to: chat)
    appState.update(selectedChat: chat)
    sut.userInput = testInput
    //when
    sut.backUpUserInput()
    //then
    XCTAssertEqual(testInput, appState.userData.chats[id]?.userInput)
  }
  
  @MainActor
  func test_preformOnAppear() {
    //given
    let testInput = "this is a test"
    var chat = Chat(members: ["tester"])
    chat.userInput = testInput
    appState.update(chatAtID: "test", to: chat)
    appState.update(selectedChat: chat)
    XCTAssertTrue(appState.routing.showBottomNavigation)
    //when
    sut.preformOnAppear()
    //then
    XCTAssertFalse(appState.routing.showBottomNavigation)
    XCTAssertEqual(sut.appStateSubs.count, 2)
    XCTAssertEqual(sut.userInput, testInput)
  }
  
  @MainActor
  func test_preformOnDisappear() {
    //given
    sut.subscribeToState(selectedChatId: "test")
    appState.toggleBottomNavigation()
    XCTAssertEqual(sut.appStateSubs.count, 2)
    XCTAssertFalse(appState.routing.showBottomNavigation)
    //when
    sut.preformOnDisappear()
    //then
    XCTAssertTrue(appState.routing.showBottomNavigation)
    XCTAssertEqual(sut.appStateSubs.count, 0)
  }
}

