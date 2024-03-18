//
//  VMContainer.swift
//  MyChat
//
//  Created by Nikita Ivanov on 09/03/2024.
//

extension DIContainer {
  struct Interactors {
    let authViewModel: AuthViewModel?
    let chatsViewModel: ChatsViewModel?
    
    static var stub: Self {
      .init(authViewModel: nil, chatsViewModel: nil)
    }
    
    
//    static var stub: Interactors {
//      let authViewModel = Task {
//        await MainActor.run {
//          AuthViewModel(authService: MockAuthService(),
//                                             appState: AppState.preview)
//        }
//      }
//      let chatsViewModel = await MainActor.run {
//          ChatsViewModel(appState: AppState.preview)
//      }
//      return Interactors(authViewModel: authViewModel, chatsViewModel: chatsViewModel)
//    }
  }
}
