//
//  AppState.swift
//  MyChat
//
//  Created by Nikita Ivanov on 21/02/2024.
//

import Combine

@MainActor
final class AppState {
  private (set) var userData: CurrentValueSubject<UserData, Never>
  private (set) var routing: CurrentValueSubject<ViewRouting, Never>
  
  nonisolated init(userData: UserData = UserData(),
                   routing: ViewRouting = ViewRouting()) {
    self.userData = CurrentValueSubject<UserData,Never>(userData)
    self.routing = CurrentValueSubject<ViewRouting,Never>(routing)
  }
}

extension AppState {
  struct UserData {
    var authState: AuthState = .unauthenticated
    
    var uid: String?
    var username: String?
    
    var error: String?
    
    var selectedChatID: String? = nil
    var chats: ChatTable = ChatTable()
  }
  
  struct ViewRouting {
    var showBottomNavigation = true
    var showCreateChatView = false
  }
}

// MARK: - UserData Actions
extension AppState {
  func update(uid: String?, username: String?) {
    userData.value.uid = uid
    userData.value.username = username
  }
  
  func update(authState: AuthState) {
    userData.value.authState = authState
  }
  
  func update(error: String?) {
    userData.value.error = error
  }
  
  /// Updates the chat dictionary at specified id, if the id doesn't exist creates a Chat at that id.
  func update(chatAtID id: String, to chat: Chat) {
    userData.value.chats[id] = chat
  }
  
  func update(messagesAtID id: String, to messages: [Message]?) {
    userData.value.chats[id]?.messages = messages
  }
  
  func update(chats: ChatTable) {
    userData.value.chats = chats
  }
  
  func update(selectedChat: Chat) {
    userData.value.selectedChatID =
    userData.value.chats.key(forValue: selectedChat)
  }
  
  func update(userInput: String, forChatAtID id: String) {
    userData.value.chats[id]?.userInput = userInput
  }
}

// MARK: - ViewRouting Actions
extension AppState {
  func toggleBottomNavigation() {
    routing.value.showBottomNavigation.toggle()
  }
  
  func toggleShowCreateChatView() {
    routing.value.showCreateChatView.toggle()
  }
}
