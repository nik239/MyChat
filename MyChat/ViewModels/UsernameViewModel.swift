//
//  SetUsernameViewModel.swift
//  MyChat
//
//  Created by Nikita Ivanov on 09/04/2024.
//

import SwiftUI
import Combine

enum UsernameState {
  case notSet
  case updating
  case error
}

@MainActor
final class UsernameViewModel: ObservableObject {
  let authService: AuthService
  
  let appState: AppState
  var appStateSub: AnyCancellable?

  @Published var usernameState: UsernameState = .notSet
  @Published var userEntry: String = ""
  @Published var error: String = ""
  
  
  nonisolated init(authService: AuthService, appState: AppState){
    self.appState = appState
    self.authService = authService
  }
  
  func subscribeToState() {
    appStateSub = appState.$userData
      .map { $0.error ?? ""}
      .removeDuplicates()
      .sink { self.error = $0 }
  }
  
  func unsubscribeFromState() {
    appStateSub?.cancel()
    appStateSub = nil
  }
  
  func setUsername() {
    usernameState = .updating
    Task {
      do {
        try await authService.setUsername(newName: userEntry)
      }
      catch {
        self.usernameState = .error
      }
    }
  }
}
