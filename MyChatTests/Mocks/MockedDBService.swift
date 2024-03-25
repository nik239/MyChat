//
//  MockedDBService.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 25/03/2024.
//

import XCTest
@testable import MyChat

struct MockedDBService: Mock, DBService {
  enum Action: Equatable {
    case sendMessage(message: Message, toChatWithID: String)
    case updateChat(chat: Chat, withID: String?)
  }
  
  let actions: MockActions<Action>
  
  init(expected: [Action]){
    self.actions = .init(expected: expected)
  }
  
  func sendMessage(message: Message, toChatWithID id: String) async throws {
    register(.sendMessage(message: message, toChatWithID: id))
  }
  
  func updateChat(chat: Chat, withID id: String?) async throws {
    register(.updateChat(chat: chat, withID: id))
  }
}
