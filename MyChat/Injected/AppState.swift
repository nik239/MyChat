//
//  AppState.swift
//  MyChat
//
//  Created by Nikita Ivanov on 21/02/2024.
//

import Foundation
import FirebaseAuth

final class AppState: ObservableObject {
  @Published private (set) var userData = UserData()

}

extension AppState {
  struct UserData {
    var user: User?
    var chats: [String: Chat] = [:]
  }
}


// MARK: - Actions
extension AppState {
  func update(user: User?) {
    Task {
      await MainActor.run {
        self.userData.user = user
      }
    }
  }
  
  func update(chatAtID id: String, to chat: Chat) {
    Task {
      await MainActor.run {
        self.userData.chats[id] = chat
      }
    }
  }
}
