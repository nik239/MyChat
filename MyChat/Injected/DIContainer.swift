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
  @MainActor
  static var preview: Self {
    .init(viewModels: .stub)
  }
}
#endif

// MARK: - View Models
extension DIContainer {
  struct ViewModels {
    let authViewModel: AuthViewModel
    let chatsViewModel: ChatsViewModel
    let chatViewModel: ChatViewModel
    
    @MainActor
    static var stub: Self {
      .init(authViewModel: AuthViewModel(authService: StubAuthService(),
                                         appState: .preview),
            chatsViewModel: ChatsViewModel(appState: .preview),
            chatViewModel: ChatViewModel(fsService: StubFireStoreService(),
                                         appState: .preview))
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
  }
}
