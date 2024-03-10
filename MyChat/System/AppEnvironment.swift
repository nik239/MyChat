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
    let interactors = await configuredInteractors(services: services)
    let container = DIContainer(appState: appState, interactors: interactors)
    return AppEnvironment(container: container)
  }
  
  private static func configuredServices(appState: AppState) -> DIContainer.FirebaseServices {
    return .init(authService: RealAuthenticationService(appState: appState), firestoreService: FirestoreService(appState: appState))
  }
  
  private static func configuredInteractors(services: DIContainer.FirebaseServices) async -> DIContainer.Interactors {
      let authViewModel = await MainActor.run {
        AuthViewModel(authService: services.authService)
      }
    return .init(authViewModel: authViewModel)
  }
}

extension DIContainer {
  struct FirebaseServices {
    let authService: AuthenticationService
    let firestoreService: FirestoreService
  }
}
