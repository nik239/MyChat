//
//  ChatViewModel.swift
//  MyChat
//
//  Created by Nikita Ivanov on 18/03/2024.
//

import SwiftUI

@MainActor
final class ChatViewModel: ObservableObject {
  let appState: AppState
  let fsService: DBService
  
  @Published var newMessageContent: String = ""
  
  @Published var chatName: String?
  @Published var messages: [Message]?
  
  init(fsService: DBService, appState: AppState) {
    self.appState = appState
    self.fsService = fsService
    appState.$userData
      .receive(on: DispatchQueue.main)
      .map {
        $0.selectedChat?.messages
      }
      .assign(to: &$messages)
    appState.$userData
      .receive(on: DispatchQueue.main)
      .map {
        $0.selectedChat?.name
      }
      .assign(to: &$chatName)
  }
  
  func isAuthorSelf(message: Message) -> Bool {
    return message.author == appState.userData.user?.displayName
  }
  
  func sendMessage() {
    guard let author = appState.userData.user?.displayName,
          let chatID = appState.userData.selectedChatID else {
      return
    }
    let message = Message(author: author, content: newMessageContent)
    Task {
      do {
        try await fsService.sendMessage(message: message, toChatWithID: chatID)
      } catch {
        print(error)
      }
    }
  }
  
  func toggleBottomNavigation() {
    appState.toggleBottomNavigation()
  }
}
