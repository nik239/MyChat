//
//  AppState.swift
//  MyChat
//
//  Created by Nikita Ivanov on 21/02/2024.
//

import Foundation
import Combine
import FirebaseAuth

final class AppState: ObservableObject {
  @Published private (set) var userData = UserData()
  @Published private (set) var routing = ViewRouting()
}

extension AppState {
  struct UserData {
    var user: User?
    
    var authState: AuthState = .unauthenticated
    var authError: String = ""
    
    var chats: [String: Chat] = [:]
    
    //should use selectedChatID instead, no?
    var selectedChat: Chat? = nil
    var selectedChatID: String? = nil
  }
  
  struct ViewRouting {
    var showBottomNavigation = true
  }
}

// MARK: - UserData Actions
extension AppState {
  func update(user: User?) {
    Task {
      await MainActor.run {
        userData.user = user
      }
    }
  }
  
  func update(chatAtID id: String, to chat: Chat) {
    Task {
      await MainActor.run {
        userData.chats[id] = chat
      }
    }
  }
  
  func update(authState: AuthState) {
    Task {
      await MainActor.run {
        userData.authState = authState
      }
    }
  }
  
  func update(authError: String) {
    Task {
      await MainActor.run {
        userData.authError = authError
      }
    }
  }
  
  func update(selectedChat: Chat) {
    Task {
      await MainActor.run {
        userData.selectedChat = selectedChat
        userData.selectedChatID = userData.chats.key(forValue: selectedChat)
      }
    }
  }
  
  func update(userInput: String, forChatAtID id: String) {
    Task {
      await MainActor.run {
        userData.chats[id]?.userInput = userInput
      }
    }
  }
}

// MARK: - ViewRouting Actions
extension AppState {
  func toggleBottomNavigation() {
    Task {
      await MainActor.run {
        routing.showBottomNavigation.toggle()
      }
    }
  }
}

#if DEBUG
// MARK: - Preview
extension AppState {
  static var preview: AppState {
    let preview = AppState()
    var chat1 = Chat(members: [], name: "Sam")
    var chat2 = Chat(members: [], name: "Merry")
    var chat3 = Chat(members:[], name: "Pipppin")
    let messageContent = "Hey, what's up. Hope everything is well. Do you have the ring? I was wondering if I could I borrow it for a little while."
    let messageContent2 = "Hey, this is Merry. Hope everything is well. Do you have the ring? I was wondering if I could I borrow it for a little while."
    chat1.messages = [Message(author: "Sam", content: messageContent)]
    chat2.messages = [Message(author: "Merry", content: messageContent2)]
    chat3.messages = [Message(author: "Pippin", content: messageContent)]
    preview.update(chatAtID: "1", to: chat1)
    preview.update(chatAtID: "2", to: chat2)
    preview.update(chatAtID: "3", to: chat3)
//    preview.update(chatAtID: "4", to: chat1)
//    preview.update(chatAtID: "5", to: chat2)
//    preview.update(chatAtID: "6", to: chat3)
//    preview.update(chatAtID: "7", to: chat1)
//    preview.update(chatAtID: "8", to: chat2)
//    preview.update(chatAtID: "9", to: chat3)
    preview.update(selectedChat: chat1)
    preview.update(authState: .authenticated)
    
    return preview
  }
}
#endif
