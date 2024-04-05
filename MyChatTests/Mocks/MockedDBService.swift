//
//  MockedDBService.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 25/03/2024.
//

import XCTest
@testable import MyChat

final class MockedDBService: Mock, DBService {
  enum Action: Equatable {
    case sendMessage(message: Message, toChatWithID: String)
    case updateChat(chat: Chat, withID: String?)
    
    //Need simplified Message equality check for testing
    static func ==(lhs: Action, rhs: Action) -> Bool {
      switch (lhs, rhs) {
      case let (.sendMessage(lhsMessage, lhsChatID), .sendMessage(rhsMessage, rhsChatID)):
        return lhsChatID == rhsChatID && lhsMessage.content == rhsMessage.content
          
      case let (.updateChat(lhsChat, lhsID), .updateChat(rhsChat, rhsID)):
        return lhsChat == rhsChat && lhsID == rhsID
        
      case (.sendMessage, _), (.updateChat, _):
        return false
      }
    }
  }
  
  var actions: MockActions<Action>
  
  init(expected: [Action] = []){
    self.actions = .init(expected: expected)
  }
  
  func sendMessage(message: Message, toChatWithID id: String) async throws {
    register(.sendMessage(message: message, toChatWithID: id))
  }
  
  func updateChat(chat: Chat, withID id: String?) async throws {
    register(.updateChat(chat: chat, withID: id))
  }
}
