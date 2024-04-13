//
//  CreateChatViewModel.swift
//  MyChat
//
//  Created by Nikita Ivanov on 12/04/2024.
//

import SwiftUI

@MainActor
final class CreateChatViewModel: ObservableObject {
  private var appState: AppState
  private var dbService: DBService?
  
  @Published var addingMembers = false
  @Published var isValid: Bool = false
  
  @Published var chatNameEntry = ""
  @Published var memberEntry = ""
  
  @Published var allMembers = ""
  private var members: [String] = []

  @Published var error = ""
  
  nonisolated init(appState: AppState, dbService: DBService) {
    self.appState = appState
    self.dbService = dbService
  }
  
  func addMember() {
    members.append(memberEntry)
    allMembers = members.joined(separator: ", ")
    isValid = members != []
  }
  
  func createChat() {
    let chat = Chat(members: members, name: chatNameEntry)
    Task {
      do {
        try await dbService?.updateChat(chat: chat, withID: nil)
        appState.toggleShowCreateChatView()
      }
      catch {
        self.error = "\(error)"
      }
    }
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
