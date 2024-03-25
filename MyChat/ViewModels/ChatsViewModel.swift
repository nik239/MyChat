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
  let appState: AppState
  init(appState: AppState) {
    self.appState = appState
    appState.$userData
      .receive(on: DispatchQueue.main)
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
  
  nonisolated func messagePreview(chat: Chat) -> String {
    return chat.messages?.last?.content ?? ""
  }
  
  nonisolated func lastMessageDate(chat: Chat) -> String {
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
  
  nonisolated func didTapOnChat(chat: Chat) {
    appState.update(selectedChat: chat)
  }
}

