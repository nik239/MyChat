//
//  ProfileViewModel.swift
//  MyChat
//
//  Created by Nikita Ivanov on 21/03/2024.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
  let authService: AuthService
  
  @Published var userHandle: String = "SomeUser"
  @Published var isEdditing: Bool = false
  
  init(authService: AuthService, appState: AppState) {
    self.authService = authService
    appState.$userData
      .map {
        $0.user?.displayName ?? ""
      }
      .assign(to: &$userHandle)
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
