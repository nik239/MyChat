//
//  AppState.swift
//  MyChat
//
//  Created by Nikita Ivanov on 21/02/2024.
//

import Foundation
import FirebaseAuth

struct AppState {
  var userData = UserData()
}

extension AppState {
  struct UserData {
    var user: User?
  }
}
