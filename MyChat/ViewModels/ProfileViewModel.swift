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
  
  @Published var userHandle: String = "Unknown"
  
//  private var cancellables = Set<AnyCancellable>()
  
  init(authService: AuthService, appState: AppState) {
    self.authService = authService
    appState.$userData
      .receive(on: DispatchQueue.main)
      .map {
        $0.user?.displayName ?? "Unknown"
      }
      .assign(to: &$userHandle)
    
//    appState.$userData
//        .map { $0.user?.displayName ?? "Unknown" }
//        .sink { displayName in
//            DispatchQueue.main.async { [weak self] in
//                self?.userHandle = displayName
//            }
//        }
//        .store(in: &cancellables)
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
