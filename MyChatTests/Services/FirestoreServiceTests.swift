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
  }
  
  func test_createChat() async {
    //given
    let chat = Chat(members: [""], pending: [""], name: "testChat")
    do {
      //when
      try await dbService.createChat(chat: chat)
    } catch {
      //then
      XCTFail("createChat threw: \(error)")
    }
  }
  
  func test_sendMessage() async {
    //gien
    let testID = "test1"
    let chat = Chat(members: [""], pending: [""], name: "testChat")
    let message = Message(author: "testUser", content: "test")
    //when
    try! await dbService.createChat(chat: chat, withID: testID)
    do {
      try await dbService.sendMessage(message: message, toChat: testID)
    } catch {
    //then
      XCTFail("sendMessage threw: \(error)")
    }
  }
  
  func test_createMessagesListener() async {
    //gien
    let testID = "test2"
    let chat = Chat(members: [""], pending: [""], name: "testChat")
    let message = Message(author: "testUser", content: "test")
    //when
    do {
      try await dbService.createMessagesListener(withChatID: testID)
    } catch {
      XCTFail("createMessagesListener threw \(error)")
    }
    try! await dbService.createChat(chat: chat, withID: testID)
    try! await dbService.sendMessage(message: message, toChat: testID)
    //XCTAssertEqual
    
  }
}
