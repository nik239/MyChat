//
//  ChatViewModel.swift
//  MyChat
//
//  Created by Nikita Ivanov on 18/03/2024.
//

import SwiftUI
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
  let dbService: DBService
  
  let appState: AppState
  var appStateSubs = Set<AnyCancellable>()
  
  @Published var chatName: String?
  @Published var messages: [Message]?
  
  @Published var userInput: String = ""
  //Text Editor UI
  var editorHeight: CGFloat = 20
  let maxHeight: CGFloat = 100
  let editorWidth: CGFloat = UIScreen.main.bounds.width * 0.75
  let editorFont: Font = .body
  
  nonisolated init(dbService: DBService, appState: AppState) {
    self.appState = appState
    self.dbService = dbService
  }
  
  func subscribeToState(selectedChatId id: String) {
    bindToMessages(withChatID: id)
    bindToChatName(withChatID: id)
  }
  
  func unsubscribeFromState() {
    appStateSubs.removeAll()
    appStateSubs = Set<AnyCancellable>()
  }
  
  private func bindToMessages(withChatID id: String) {
    appState.$userData
      .compactMap { $0.chats[id]?.messages }
      .removeDuplicates()
      .sink { self.messages = $0 }
      .store(in: &appStateSubs)
  }
  
  private func bindToChatName(withChatID id: String) {
    appState.$userData
      .compactMap { $0.chats[id]?.name }
      .removeDuplicates()
      .sink { self.chatName = $0 }
      .store(in: &appStateSubs)
  }
}


// MARK: ChatViewModel - sendMessage
extension ChatViewModel {
  func sendMessage() {
    #if DEBUG
    let author = appState.userData.user?.displayName ?? "tester"
    guard let chatID = appState.userData.selectedChatID else {
      return
    }
    #else
    guard let author = appState.userData.user?.displayName,
          let chatID = appState.userData.selectedChatID else {
      return
    }
    #endif
    let message = Message(author: author, content: userInput)
    Task {
      do {
        try await dbService.sendMessage(message: message, toChatWithID: chatID)
      } catch {
        print(error)
      }
    }
  }
}

//MARK: - ChatViewModel - UI
extension ChatViewModel {
  func isAuthorSelf(message: Message) -> Bool {
    return message.author == appState.userData.user?.displayName
  }
  
  func calculateTextHeight() {
    if userInput == "" {
      editorHeight = 20
      return
    }
    let textView = UITextView(frame: CGRect(x: 0, y: 0, width: editorWidth, height: CGFloat.greatestFiniteMagnitude))
    textView.text = userInput
    textView.font = UIFont.preferredFont(from: editorFont)
    textView.sizeToFit()
    editorHeight =  min(textView.frame.height, maxHeight)
  }
}
  

// MARK: - ChatViewModel - LifeCycle
extension ChatViewModel {
  func preformOnAppear() {
    appState.toggleBottomNavigation()
    if let selectedChatID = appState.userData.selectedChatID {
      subscribeToState(selectedChatId: selectedChatID)
      userInput = appState.userData.chats[selectedChatID]?.userInput ?? ""
    }
  }
  
  func preformOnDisappear() {
    appState.toggleBottomNavigation()
    unsubscribeFromState()
    backUpUserInput()
  }
  
  func backUpUserInput() {
    guard let chatID = appState.userData.selectedChatID else {
      return
    }
    appState.update(userInput: userInput, forChatAtID: chatID)
  }
}
