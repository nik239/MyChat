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
  
  @Published var chatName: String?
  @Published var messages: [Message]?
  
  @Published var userInput: String = ""
  
  //Text Editor UI
  var editorHeight: CGFloat = 20
  let maxHeight: CGFloat = 100
  let editorWidth: CGFloat = UIScreen.main.bounds.width * 0.75
  let editorFont: Font = .body
  
  init(fsService: DBService, appState: AppState) {
    self.appState = appState
    self.fsService = fsService
    bindToMessages()
    bindToChatName()
  }
  
  private func bindToMessages() {
    appState.$userData
      .receive(on: DispatchQueue.main)
      .map {
        $0.selectedChat?.messages
      }
      .assign(to: &$messages)
  }
  
  private func bindToChatName() {
    appState.$userData
      .receive(on: DispatchQueue.main)
      .map {
        $0.selectedChat?.name
      }
      .assign(to: &$chatName)
  }
}


// MARK: ChatViewModel - sendMessage
extension ChatViewModel {
  func sendMessage() {
    guard let author = appState.userData.user?.displayName,
          let chatID = appState.userData.selectedChatID else {
      return
    }
    let message = Message(author: author, content: userInput)
    Task {
      do {
        try await fsService.sendMessage(message: message, toChatWithID: chatID)
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
  
  func calculateTextHeight() -> CGFloat {
    let textView = UITextView(frame: CGRect(x: 0, y: 0, width: editorWidth, height: CGFloat.greatestFiniteMagnitude))
    textView.text = userInput
    textView.font = UIFont.preferredFont(forTextStyle: .body)
    textView.sizeToFit()
    return textView.frame.height
  }
}
  

// MARK: - ChatViewModel - LifeCycle
extension ChatViewModel {
  func preformOnAppear() {
    appState.toggleBottomNavigation()
    userInput = appState.userData.selectedChat?.userInput ?? ""
  }
  
  func preformOnDisappear() {
    appState.toggleBottomNavigation()
    backUpUserInput()
  }
  
  func backUpUserInput() {
    guard let chatID = appState.userData.selectedChatID else {
      return
    }
    appState.update(userInput: userInput, forChatAtID: chatID)
  }
}
