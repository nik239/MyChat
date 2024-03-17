//
//  ChatsViewModel.swift
//  MyChat
//
//  Created by Nikita Ivanov on 13/03/2024.
//

import Foundation
import SwiftUI
import Combine

protocol ChatsViewModel: ObservableObject {
  @MainActor var chats: [Chat]? { get set }
}

@MainActor
final class RealChatsViewModel: ChatsViewModel {
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

@MainActor 
final class StubChatsViewModel: ChatsViewModel {
  @Published var chats: [Chat]? = nil
  init() {
    var chat1 = Chat(members: ["Frodo, Sam, Pippin"], name: "Shire")
    let message1 = Message(author: "Pippin", content: "Who's got the ring?")
    chat1.messages = [message1]
    var chat2 = Chat(members: ["Jesse"], name: "Jesse")
    let message2 = Message(author: "Jesse", content: "Yo, Mr. White, where have you been? We have to coooooooooooooooook!")
    chat2.messages = [message2]
    self.chats = [chat1, chat2]
  }
}
