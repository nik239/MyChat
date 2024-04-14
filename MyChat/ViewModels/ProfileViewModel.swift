//
//  ProfileViewModel.swift
//  MyChat
//
//  Created by Nikita Ivanov on 21/03/2024.
//

import SwiftUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
  let authService: AuthService
  
  let appState: AppState
  var appStateSubs = Set<AnyCancellable>()
  
  @Published var username: String = "Unknown"
  @Published var usernameState: UsernameState = .set
  @Published var error: String = ""
  @Published var showAlert = false
  
  
  nonisolated init(authService: AuthService, appState: AppState) {
    self.authService = authService
    self.appState = appState
  }
  
  func setUserName() {
    Task {
      usernameState = .updating
      do {
        try await authService.setUsername(newName: username)
        usernameState = .set
      } catch {
        usernameState = .error
      }
    }
  }
  
  func signOut() {
    authService.signOut()
  }
  
  func deleteAccount() {
    Task {
      await authService.deleteAccount()
    }
  }
}

//MARK: - ProfileViewModel State Subscription Managment
extension ProfileViewModel {
  func subscribeToState() {
    appState.userData
      .map { $0.username ?? "Unknown"}
      .removeDuplicates()
      .sink { self.username = $0 }
      .store(in: &appStateSubs)
    appState.userData
      .map { $0.error ?? ""}
      .removeDuplicates()
      .sink { self.error = $0 }
      .store(in: &appStateSubs)
  }
  
  func unsubscribeFromState() {
    appStateSubs.removeAll()
    appStateSubs = Set<AnyCancellable>()
  }
}
