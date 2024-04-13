//
//  AppState.swift
//  MyChat
//
//  Created by Nikita Ivanov on 21/02/2024.
//

import FirebaseAuth
import Combine

@MainActor
final class AppState {
  private (set) var userData: CurrentValueSubject<UserData, Never>// = UserData()
  private (set) var routing: CurrentValueSubject<ViewRouting, Never>// = ViewRouting()
  
  nonisolated init(userData: UserData = UserData(),
                   routing: ViewRouting = ViewRouting()) {
    self.userData = CurrentValueSubject<UserData,Never>(userData)
    self.routing = CurrentValueSubject<ViewRouting,Never>(routing)
  }
}

extension AppState {
  struct UserData {
    var user: User?
    
    var authState: AuthState = .unauthenticated
    var error: String?
    
    var selectedChatID: String? = nil
    var chats: ChatTable = ChatTable()
  }
  
  struct ViewRouting {
    var showBottomNavigation = true
  }
}

// MARK: - UserData Actions
extension AppState {
  func update(user: User?) {
    userData.value.user = user
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
}

#if DEBUG
// MARK: - Preview
extension AppState {
  nonisolated static var preview: AppState {
      var chat1 = Chat(members: [], name: "Sam")
      var chat2 = Chat(members: [], name: "Merry")
      var chat3 = Chat(members: [], name: "Pipppin")
      let messageContent = "Hey, what's up. Hope everything is well. Do you have the ring? I was wondering if I could I borrow it for a little while."
      let messageContent2 = "Hey, this is Merry. Hope everything is well. Do you have the ring? I was wondering if I could I borrow it for a little while."
      chat1.messages = [Message(author: "Sam", content: messageContent)]
      chat2.messages = [Message(author: "Merry", content: messageContent2)]
      chat3.messages = [Message(author: "Pippin", content: messageContent)]
      let userData = AppState.UserData(user: nil,
                                       authState: .unauthenticated,
                                       error: "",
                                       selectedChatID: "1",
                                       chats: ["1": chat1, "2": chat2, "3": chat3])
      let routing = AppState.ViewRouting(showBottomNavigation: true)
      let preview = AppState(userData: userData, routing: routing)
      return preview
  }
}

extension AppState {
  func update(selectedChatID: String) {
    userData.value.selectedChatID = selectedChatID
  }
}
#endif
