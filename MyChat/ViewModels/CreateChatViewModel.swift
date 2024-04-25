//
//  CreateChatViewModel.swift
//  MyChat
//
//  Created by Nikita Ivanov on 12/04/2024.
//

import SwiftUI
import Combine
import PrefixLookup

@MainActor
final class CreateChatViewModel: ObservableObject {
  private var dbService: DBService
  private var appState: AppState
  
  var appStateSub: AnyCancellable?
  
  @Published var addingMembers = false
  @Published var isValid: Bool = false
  
  @Published var chatNameEntry = ""
  @Published var memberEntry = ""
  
  @Published var allMembers = ""
  private var members: [String] = []

  @Published var error = ""
  @Published var searchText = ""
  
  private var loader: PrefixLoader?
  
  private var flagAwaitingNewChat = false
  
  nonisolated init(dbService: DBService, appState: AppState) {
    self.appState = appState
    self.dbService = dbService
  }
  
  func addMember() {
    members.append(memberEntry)
    allMembers = members.joined(separator: ", ")
    isValid = members != []
    memberEntry = ""
  }
  
  func createChat() {
    let chat = Chat(members: members, name: chatNameEntry)
    Task {
      do {
        try await dbService.createNewChat(chat: chat)
      }
      catch {
        self.error = "\(error)"
      }
    }
  }
  
  func reloadUsers() {
    
  }
  
  func subscribeToState() {
    appStateSub = appState.userData
      .compactMap { $0.newChatID }
      .sink { id in
        guard self.flagAwaitingNewChat else {
          return
        }
        self.switchToNewChat(id: id)
      }
  }
  
  func switchToNewChat(id: String) {
    self.flagAwaitingNewChat = false
    self.appState.update(selectedChatID: id)
    self.appState.toggleShowCreateChatView()
    self.appState.toggleShowChatView()
  }
  
  func preformOnDisappear() {
    members = []
    allMembers = ""
    chatNameEntry = ""
    memberEntry = ""
    isValid = false
    addingMembers = false
  }
}
