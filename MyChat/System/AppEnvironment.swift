//
//  AppEnvironment.swift
//  MyChat
//
//  Created by Nikita Ivanov on 09/03/2024.
//

struct AppEnvironment {
  let container: DIContainer
}

extension AppEnvironment {
  static func bootstrap() -> AppEnvironment {
    let appState = AppState()
    let services = configuredServices(appState: appState)
    let viewModels = configuredInteractors(services: services, appState: appState)
    let container = DIContainer(viewModels: viewModels)
//    let container = DIContainer.preview
    return AppEnvironment(container: container)
  }
  
  private static func configuredServices(appState: AppState) -> DIContainer.FirebaseServices {
    return .init(authService: RealAuthService(appState: appState), firestoreService: FireStoreService(appState: appState))
  }
  
  private static func configuredInteractors(services: DIContainer.FirebaseServices, appState: AppState) -> DIContainer.ViewModels {
    let authViewModel = AuthViewModel(authService: services.authService, appState: appState)
    let chatsViewModel = ChatsViewModel(appState: appState)
    let chatViewModel = ChatViewModel(dbService: services.firestoreService, appState: appState)
    let profileViewModel = ProfileViewModel(authService: services.authService, appState: appState)
    let bottomNavigationViewModel = BottomNavigationViewModel(appState: appState)
    return .init(authViewModel: authViewModel,
                 chatsViewModel: chatsViewModel,
                 chatViewModel: chatViewModel,
                 profileViewModel: profileViewModel,
                 bottomNavigationViewModel: bottomNavigationViewModel)
  }
}

extension DIContainer {
  struct FirebaseServices {
    let authService: AuthService
    let firestoreService: FireStoreService
  }
}
