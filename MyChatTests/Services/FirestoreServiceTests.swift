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
    dbService = FirestoreService(appState: AppState())
  }
  
  override func tearDownWithError() throws {
    dbService = nil
  }
  
  func test_createChat() async {
    //when
    let chat = Chat(members: [""], pending: [""], name: "testChat")
    do {
      try await dbService.createChat(chat: chat)
    } catch {
      //then
      XCTFail("createChat threw: \(error)")
    }
  }
}
