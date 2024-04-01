//
//  ChatsViewModel.swift
//  MyChat
//
//  Created by Nikita Ivanov on 13/03/2024.
//

import SwiftUI
import Combine

@MainActor
final class ChatsViewModel: ObservableObject {
  let appState: AppState
  private var appStateSub: AnyCancellable?
  
  @Published var chats: [Chat]?
  
  nonisolated init(appState: AppState) {
    self.appState = appState
  }
  
  func subscribeToState() {
    appStateSub = appState.$userData
      .compactMap { Array($0.chats.values) }
      .removeDuplicates()
      .sink { chatsArr in
        self.chats = chatsArr.sorted() {self.isMoreRecent($0, then: $1)}
      }
  }
  
  func unsubscribeFromState() {
    appStateSub?.cancel()
  }
  
  func isMoreRecent(_ chat1: Chat, then chat2: Chat) -> Bool {
    guard let date0 = chat1.messages?.last?.date else {
      return false
    }
    guard let date1 = chat2.messages?.last?.date else {
      return true
    }
    return date0 > date1
  }
  
  func messagePreview(chat: Chat) -> String {
    return chat.messages?.last?.content ?? ""
  }
  
  func lastMessageDate(chat: Chat) -> String {
    guard let date = chat.messages?.last?.date else {
      return ""
    }
    let calendar = Calendar.current
    let now = Date()
    let dateFormatter = DateFormatter()
    
    if calendar.isDateInToday(date) {
      dateFormatter.timeStyle = .short
      return dateFormatter.string(from: date)
    }
    
    if calendar.isDateInYesterday(date) {
      return "Yesterday"
    }
    
    let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
    if date >= startOfWeek {
      dateFormatter.dateFormat = "EEEE"
      return dateFormatter.string(from: date)
    }
    
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none

    return dateFormatter.string(from: date)
  }
  
  func didTapOnChat(chat: Chat) {
    Task {
      await appState.update(selectedChat: chat)
    }
  }
}

