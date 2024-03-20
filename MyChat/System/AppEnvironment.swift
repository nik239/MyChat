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
  static func bootstrap() async -> AppEnvironment {
    let appState = AppState()
    let services = configuredServices(appState: appState)
    let viewModels = await configuredInteractors(services: services, appState: appState)
    let container = DIContainer(viewModels: viewModels)
    return AppEnvironment(container: container)
  }
  
  private static func configuredServices(appState: AppState) -> DIContainer.FirebaseServices {
    return .init(authService: RealAuthService(appState: appState), firestoreService: RealFireStoreService(appState: appState))
  }
  
  private static func configuredInteractors(services: DIContainer.FirebaseServices, appState: AppState) async -> DIContainer.ViewModels {
    let authViewModel = await MainActor.run {
      AuthViewModel(authService: services.authService, appState: appState)
    }
    let chatsViewModel = await MainActor.run {
      ChatsViewModel(appState: appState)
    }
    let chatViewModel = await MainActor.run {
      ChatViewModel(fsService: services.firestoreService, appState: appState)
    }
    return .init(authViewModel: authViewModel, chatsViewModel: chatsViewModel, chatViewModel: chatViewModel)
  }
}

extension DIContainer {
  struct FirebaseServices {
    let authService: AuthService
    let firestoreService: RealFireStoreService
  }
}
