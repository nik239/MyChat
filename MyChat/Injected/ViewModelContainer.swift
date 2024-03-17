//
//  VMContainer.swift
//  MyChat
//
//  Created by Nikita Ivanov on 09/03/2024.
//

extension DIContainer {
  struct Interactors {
    let authViewModel: RealAuthViewModel?
    let chatsViewModel: RealChatsViewModel?
    
    static var stub: Self {
      .init(authViewModel: nil, chatsViewModel: nil)
    }
  }
}
