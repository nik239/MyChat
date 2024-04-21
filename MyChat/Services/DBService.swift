//
//  FireStoreService.swift
//  MyChat
//
//  Created by Nikita Ivanov on 22/02/2024.
//

import FirebaseFirestore
import Combine

protocol DBService {
  func sendMessage(message: Message, toChatWithID id: String) async throws
  func updateChat(chat: Chat, withID id: String?) async throws
  func createNewChat(chat: Chat) async throws
}

// MARK: - StubFireStoreService
final class StubFireStoreService: DBService {
  func sendMessage(message: Message, toChatWithID id: String) async throws { }
  func updateChat(chat: Chat, withID id: String?) async throws { }
  func createNewChat(chat: Chat) async throws { }
}
