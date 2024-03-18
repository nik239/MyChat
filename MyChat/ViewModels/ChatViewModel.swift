//
//  ChatViewModel.swift
//  MyChat
//
//  Created by Nikita Ivanov on 18/03/2024.
//

import SwiftUI

@MainActor
final class ChatViewModel: ObservableObject {
  @Published var messages: [Message]?
  init(appState: AppState) {
    appState.$userData
      .map {
        $0.selectedChat?.messages
      }
      .assign(to: &$messages)
  }
}
