//
//  ChatsViewModel.swift
//  MyChat
//
//  Created by Nikita Ivanov on 13/03/2024.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class ChatsViewModel: ObservableObject {
  @Published var chats: [Chat]?
  init(appState: AppState) {
    appState.$userData
      .map {
        Array($0.chats.values).sorted() {
          //sort chats by date of last message sent
          guard let date0 = $0.messages?.last?.date else {
            return false
          }
          guard let date1 = $1.messages?.last?.date else {
            return true
          }
          return date0 > date1
        }
      }
      .assign(to: &$chats)
  }
}
