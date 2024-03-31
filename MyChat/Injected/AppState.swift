//
//  AppState.swift
//  MyChat
//
//  Created by Nikita Ivanov on 21/02/2024.
//

import FirebaseAuth

@MainActor
final class AppState {
  @Published private (set) var userData = UserData()
  @Published private (set) var routing = ViewRouting()
}

extension AppState {
  struct UserData {
    var user: User?
    
    var authState: AuthState = .unauthenticated
    var error: String = ""
    
    var chats: ChatTable = ChatTable()
    var selectedChatID: String? = nil
  }
  
  struct ViewRouting {
    var showBottomNavigation = true
  }
}

// MARK: - UserData Actions
extension AppState {
  func update(user: User?) {
    userData.user = user
  }
  
  func update(authState: AuthState) {
    userData.authState = authState
  }
  
  func update(error: String) {
    userData.error = error
  }
  
  func update(chatAtID id: String, to chat: Chat) {
    userData.chats[id] = chat
  }
  
  func update(messagesAtID id: String, to messages: [Message]?) {
    userData.chats[id]?.messages = messages
  }
  
  func update(chats: ChatTable) {
    userData.chats = chats
  }
  
  func update(selectedChat: Chat) {
    userData.selectedChatID =
    userData.chats.key(forValue: selectedChat)
  }
  
  func update(userInput: String, forChatAtID id: String) {
    userData.chats[id]?.userInput = userInput
  }
}

// MARK: - ViewRouting Actions
extension AppState {
  func toggleBottomNavigation() {
    routing.showBottomNavigation.toggle()
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
