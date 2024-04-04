//
//  DIContainerMocked.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 25/03/2024.
//

@testable import MyChat

extension DIContainer.ViewModels {
  static func mocked(authService: MockedAuthService = MockedAuthService(),
                     dbService: MockedDBService = MockedDBService(),
                     appState: AppState = .preview) -> DIContainer.ViewModels {
    .init(authViewModel: AuthViewModel(authService: authService, appState: appState),
          chatsViewModel: ChatsViewModel(appState: appState),
          chatViewModel: ChatViewModel(dbService: dbService, appState: appState),
          profileViewModel: ProfileViewModel(authService: authService, appState: appState),
          bottomNavigationViewModel: BottomNavigationViewModel(appState: appState))
  }
}

extension DIContainer {
  static var mock: Self {
    .init(viewModels: .mocked())
  }
  
  static func stub(appState: AppState) -> DIContainer {
    let viewModels = ViewModels(authViewModel:
                                  AuthViewModel(authService: StubAuthService(),
                                                appState: appState),
                                chatsViewModel:
                                  ChatsViewModel(appState: appState),
                                chatViewModel: 
                                  ChatViewModel(dbService: StubFireStoreService(),
                                                appState: appState),
                                profileViewModel: 
                                  ProfileViewModel(authService: StubAuthService(),               appState: appState),
                                bottomNavigationViewModel:
                                  BottomNavigationViewModel(appState: appState))
    return .init(viewModels: viewModels)
  }
}
