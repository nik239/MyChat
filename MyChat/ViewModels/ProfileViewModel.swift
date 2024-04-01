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
  var appStateSub: AnyCancellable?
  
  @Published var userHandle: String = "Unknown"
  
  nonisolated init(authService: AuthService, appState: AppState) {
    self.authService = authService
    self.appState = appState
  }
  
  func updateUserHandle() {
    Task {
      await authService.changeUserHandle(newUserHandle: userHandle)
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
    self.appStateSub = appState.$userData
      .map { $0.user?.displayName ?? "Unknown"}
      .removeDuplicates()
      .sink { self.userHandle = $0 }
  }
  
  func unsubscribeFromState() {
    appStateSub?.cancel()
  }
}
