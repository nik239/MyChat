//
//  ProfileViewModel.swift
//  MyChat
//
//  Created by Nikita Ivanov on 21/03/2024.
//

import SwiftUI
import Combine
import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
  let authService: AuthService
  
  @Published var userHandle: String = "Unknown"
  
  init(authService: AuthService, appState: AppState) {
    self.authService = authService
    appState.$userData
      .map {
        $0.user?.displayName ?? "Unknown"
      }
      .removeDuplicates()
      .assign(to: &$userHandle)
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
