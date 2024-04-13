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
  var appStateSubs = Set<AnyCancellable>()
  
  @Published var chats: [Chat]?
  @Published var showingCreateChat: Bool = false
  
  nonisolated init(appState: AppState) {
    self.appState = appState
  }
  
  func subscribeToState() {
    appState.userData
      .compactMap { Array($0.chats.values) }
      .removeDuplicates()
      .sink { chatsArr in
        self.chats = chatsArr.sorted() {Chat.isMoreRecent($0, then: $1)}
      }
      .store(in: &appStateSubs)
    
    appState.routing
      .map { $0.showCreateChatView }
      .removeDuplicates()
      .sink {
        self.showingCreateChat = $0
      }
      .store(in: &appStateSubs)
  }
  
  func unsubscribeFromState() {
    appStateSubs.removeAll()
  }
}

//MARK: -ChatsViewModel Interaction
extension ChatsViewModel {
  func didTapOnChat(chat: Chat) {
    appState.update(selectedChat: chat)
  }
  
  func didTapAddBtn() {
    appState.toggleShowCreateChatView()
  }
}

//MARK: - ChatsViewModel Presentation
extension ChatsViewModel {
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
}

