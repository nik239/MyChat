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
  }
}
