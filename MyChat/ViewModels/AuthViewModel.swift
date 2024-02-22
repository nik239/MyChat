//
//  AuthViewModle.swift
//  MyChat
//
//  Created by Nikita Ivanov on 10/02/2024.
//

import Foundation
import SwiftUI

enum AuthFlow {
  case login
  case signUp
}

@MainActor
final class AuthViewModel: ObservableObject {
  let authService: AuthenticationService
  
  
  
  @Published var email = ""
  @Published var password = ""
  @Published var confirmPassword = ""
  
  @Published var flow: AuthFlow = .login
  
  @Published var isValid  = false
  
  init(authService: AuthenticationService = AuthenticationService()) {
    self.authService = authService
    makeIsValidPublisher()
  }
  
  private func makeIsValidPublisher() {
    $flow
      .combineLatest($email, $password, $confirmPassword)
      .map { flow, email, password, confirmPassword in
        flow == .login
          ? !(email.isEmpty || password.isEmpty)
          : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
      }
      .assign(to: &$isValid)
  }
  
  func switchFlow() {
    flow = flow == .login ? .signUp : .login
    authService.errorMessage = ""
  }
  
  func reset() {
    email = ""
    password = ""
    confirmPassword = ""
    
    flow = .login
  }
}

// MARK: - Email and Password Authentication

extension AuthViewModel {
  func signInWithEmailPassword() async -> Bool {
    await authService.signInWithEmailPassword(email: self.email, password: self.password)
  }
  
  func signUpWithEmailPassword() async -> Bool {
    await authService.signUpWithEmailPassword(email: self.email, password: self.password)
  }
}


