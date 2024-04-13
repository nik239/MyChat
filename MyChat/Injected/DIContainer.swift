//
//  DependencyInjector.swift
//  MyChat
//
//  Created by Nikita Ivanov on 09/03/2024.
//

import SwiftUI

// MARK: - DIContainer
struct DIContainer {
  let viewModels: ViewModels
  
  init(viewModels: ViewModels) {
    self.viewModels = viewModels
  }
}

#if DEBUG
extension DIContainer {
  static var preview: Self {
    .init(viewModels: .stub())
  }
}
#endif

// MARK: - View Models
extension DIContainer {
  struct ViewModels {
    let authViewModel: AuthViewModel
    let chatsViewModel: ChatsViewModel
    let chatViewModel: ChatViewModel
    let profileViewModel: ProfileViewModel
    let bottomNavigationViewModel: BottomNavigationViewModel
    let usernameViewModel: UsernameViewModel
    let createChatViewModel: CreateChatViewModel
    
    static func stub(appState: AppState = .preview) -> ViewModels {
      return .init(authViewModel: AuthViewModel(authService: StubAuthService(),
                                         appState: appState),
            chatsViewModel: ChatsViewModel(appState: appState),
            chatViewModel: ChatViewModel(dbService: StubFireStoreService(),
                                         appState: appState),
            profileViewModel: ProfileViewModel(authService: StubAuthService(),
                                               appState: appState),
            bottomNavigationViewModel: BottomNavigationViewModel(appState: appState),
            usernameViewModel: UsernameViewModel(authService: StubAuthService(),
                                                 appState: appState),
            createChatViewModel: CreateChatViewModel(dbService: StubFireStoreService()))
    }
  }
}

// MARK: - Injection in the view hierarchy
extension View {
  func inject(_ container: DIContainer) -> some View {
    return self
      .environmentObject(container.viewModels.authViewModel)
      .environmentObject(container.viewModels.chatsViewModel)
      .environmentObject(container.viewModels.chatViewModel)
      .environmentObject(container.viewModels.profileViewModel)
      .environmentObject(container.viewModels.bottomNavigationViewModel)
      .environmentObject(container.viewModels.usernameViewModel)
      .environmentObject(container.viewModels.createChatViewModel)
  }
}
