//
//  FireStoreService.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 10/03/2024.
//

import XCTest
import FirebaseFirestore
@testable import MyChat

//requires Firebase emulator to be restarted before each run
final class FirestoreServiceTests: XCTestCase {
  private var dbService: FirestoreService!
  private var appState: AppState!
  
  static var didSetEmulator = false
  
  override func setUpWithError() throws {
    if !FirestoreServiceTests.didSetEmulator {
      let settings = Firestore.firestore().settings
      settings.host = "127.0.0.1:8080"
      settings.cacheSettings = MemoryCacheSettings()
      settings.isSSLEnabled = false
      Firestore.firestore().settings = settings
      FirestoreServiceTests.didSetEmulator = true
    }
    appState = AppState()
    dbService = FirestoreService(appState: appState)
  }
  
  override func tearDownWithError() throws {
    dbService = nil
    appState = nil
  }
  
  func test_createChat() async {
    //given
    let chat = Chat(members: [""], pending: [""], name: "testChat")
    do {
      //when
      try await dbService.updateChat(chat: chat)
    } catch {
      //then
      XCTFail("createChat threw: \(error)")
    }
  }
  
  func test_sendMessage() async {
    //gien
    let chatID = "test1"
    let chat = Chat(members: [""], pending: [""], name: "testChat")
    let message = Message(author: "testUser", content: "test")
    //when
    try! await dbService.updateChat(chat: chat, withID: chatID)
    do {
      try await dbService.sendMessage(message: message, toChat: chatID)
    } catch {
    //then
      XCTFail("sendMessage threw: \(error)")
    }
  }
  
  func test_createMessagesListener() async {
    //given
    let chatID = "test2"
    let chat = Chat(members: [""], pending: [""], name: "testChat")
    appState.update(chatAtID: chatID, to: chat)
    let message = Message(author: "testUser", content: "test")
    dbService.createMessagesListener(withChatID: chatID)
    //when
    try! await dbService.updateChat(chat: chat, withID: chatID)
    try! await dbService.sendMessage(message: message, toChat: chatID)
    //then
    var messages = appState.userData.chats[chatID]!.messages!
    XCTAssertEqual(messages.count, 1)
    //when
    try! await dbService.sendMessage(message: message, toChat: chatID)
    //then
    messages = appState.userData.chats[chatID]!.messages!
    XCTAssertEqual(messages.count, 2)
  }
  
  func test_createChatsListener() async {
    //given
    let userHandle = "test_user"
    let chatID1 = "test3"
    let chatID2 = "test4"
    var chat1 = Chat(members: ["A","test_user"], pending: [""], name: "")
    let chat2 = Chat(members: ["test_user"], pending: [""], name: "testChat2")
    let message = Message(author: "A", content: "test")
    //when
    dbService.createChatsListener(forUser: userHandle)
    try! await dbService.updateChat(chat: chat1, withID: chatID1)
    try! await dbService.updateChat(chat: chat2, withID: chatID2)
    //then
    XCTAssertEqual(appState.userData.chats.count, 2)
    //when
    try! await dbService.sendMessage(message: message, toChat: chatID1)
    //then
    var messages = appState.userData.chats[chatID1]!.messages!
    XCTAssertEqual(messages.count, 1)
    //when
    chat1.name = "new_name"
    try! await dbService.updateChat(chat: chat1, withID: chatID1)
    let chatNewName = appState.userData.chats[chatID1]!.name
    XCTAssertEqual(chatNewName, "new_name")
    messages = appState.userData.chats[chatID1]!.messages!
    XCTAssertEqual(messages.count, 1)
  }
}
