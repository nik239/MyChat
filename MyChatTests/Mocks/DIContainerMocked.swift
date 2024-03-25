//
//  DIContainerMocked.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 25/03/2024.
//

@testable import MyChat

extension DIContainer.ViewModels {
  @MainActor
  static func mocked(authServiceActions: [MockedAuthService.Action] = [],
                     dbServiceActions: [MockedDBService.Action] = [],
                     appState: AppState = .preview) -> DIContainer.ViewModels {
    .init(authViewModel: AuthViewModel(authService: 
                                        MockedAuthService(expected: authServiceActions),
                                       appState: appState),
          chatsViewModel: ChatsViewModel(appState: appState),
          chatViewModel: ChatViewModel(fsService: MockedDBService(expected: dbServiceActions),
                                       appState: appState),
          profileViewModel: ProfileViewModel(authService:
                                              MockedAuthService(expected: authServiceActions),
                                             appState: appState),
          bottomNavigationViewModel: BottomNavigationViewModel(appState: appState))
  }
}
