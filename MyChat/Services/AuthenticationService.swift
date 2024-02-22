//
//  AuthService.swift
//  MyChat
//
//  Created by Nikita Ivanov on 21/02/2024.
//

import Foundation
import FirebaseAuth
import AuthenticationServices

enum AuthState {
  case unauthenticated
  case authenticating
  case authenticated
}

final class AuthenticationService: ObservableObject {
  @Published var user: User?
  @Published var displayName = ""
  
  @Published var authState: AuthState = .unauthenticated
  private var authStateHandler: AuthStateDidChangeListenerHandle?
  
  init() {
    registerAuthStateHandler()
  }
  
  private func registerAuthStateHandler() {
    if authStateHandler == nil {
      authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
        self.user = user
        self.authState = user == nil ? .unauthenticated : .authenticated
        self.displayName = user?.email ?? ""
      }
    }
  }
}

// MARK: Email and Password Authentication

extension AuthenticationService {
  
}
