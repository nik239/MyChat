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
  let fsService: FireStoreService
  
  var newMessageContent: String = ""
  
  @Published var messages: [Message]?
  init(appState: AppState, fsService: FireStoreService) {
    self.appState = appState
    self.fsService = fsService
    appState.$userData
      .map {
        $0.selectedChat?.messages
      }
      .assign(to: &$messages)
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
        try await fsService.sendMessage(message: message, toChat: chatID)
      } catch {
        print(error)
      }
    }
  }
}
