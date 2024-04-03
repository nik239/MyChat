//
//  AuthViewModle.swift
//  MyChat
//
//  Created by Nikita Ivanov on 10/02/2024.
//

import SwiftUI
import Combine
import AuthenticationServices

enum AuthFlow {
  case login
  case signUp
}

@MainActor
final class AuthViewModel: ObservableObject {
  let authService: AuthService
  let appState: AppState
  
  private var appStateSubs = Set<AnyCancellable>()
  
  @Published var authState: AuthState = .unauthenticated
  @Published var errorMessage: String = ""
  
  @Published var email = ""
  @Published var password = ""
  @Published var confirmPassword = ""
  
  @Published var flow: AuthFlow = .login
  
  @Published var isValid  = false
  
  nonisolated init(authService: AuthService, appState: AppState) {
    self.authService = authService
    self.appState = appState
    Task {
      await MainActor.run {
        subscribeToState()
        makeIsValidPublisher()
      }
    }
  }
  
  private func subscribeToState() {
    appState.$userData
      .map { $0.authState }
      .removeDuplicates()
      .sink {
        self.authState = $0
      }
      .store(in: &appStateSubs)
    appState.$userData
      .map { $0.error ?? "" }
      .removeDuplicates()
      .sink {
        self.errorMessage = $0
      }
      .store(in: &appStateSubs)
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
    authService.clearError()
  }
  
  func reset() {
    email = ""
    password = ""
    confirmPassword = ""
    
    flow = .login
  }
}

// MARK: - Authentication
extension AuthViewModel {
  func signInWithEmailPassword() {
    authService.signInWithEmailPassword(email: self.email, password: self.password)
  }
  
  func signUpWithEmailPassword() {
    authService.signUpWithEmailPassword(email: self.email, password: self.password)
  }
  
  func handleSignInWithApple(_ request: ASAuthorizationAppleIDRequest) {
    authService.handleSignInWithAppleRequest(request)
  }
  
  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
    authService.handleSignInWithAppleCompletion(result)
  }
}



