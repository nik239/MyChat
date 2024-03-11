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
final class FireStoreServiceTests: XCTestCase {
  private var dbService: FirestoreService!
  
  override func setUpWithError() throws {
    Firestore.firestore().useEmulator(withHost: "localhost", port: 8080)
    dbService = FirestoreService(appState: AppState())
  }
  
  override func tearDownWithError() throws {
    dbService = nil
  }
  
  func test_ChatsListener() {
    dbService.createChatsListener()
    
  }
}
