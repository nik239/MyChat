//
//  AppState.swift
//  MyChat
//
//  Created by Nikita Ivanov on 21/02/2024.
//

import Foundation
import FirebaseAuth

final class AppState: ObservableObject {
  @Published var userData = UserData()
}

extension AppState {
  struct UserData {
    var user: User?
    var chats: [String: Chat] = [:]
  }
}
