//
//  AuthViewModle.swift
//  MyChat
//
//  Created by Nikita Ivanov on 10/02/2024.
//

import Foundation

enum AuthStatus {
  case unauthenticated
  case authenticating
  case authenticated
}

enum AuthFlow {
  case login
  case signUp
}

@MainActor
final class AuthViewModel: ObservableObject {
  @Published var email = ""
  @Published var password = ""
  @Published var confirmPassword = ""
  
  @Published var flow: AuthFlow = .login
  
  @Published var authStatus: AuthStatus = .unauthenticated
  
  func reset() {
    email = ""
    password = ""
    confirmPassword = ""
    
    flow = .login
  }
}
