//
//  AuthViewModle.swift
//  MyChat
//
//  Created by Nikita Ivanov on 10/02/2024.
//

import Foundation
import SwiftUI
import Combine
import AuthenticationServices

enum AuthFlow {
  case login
  case signUp
}

@MainActor
protocol AuthViewModel: ObservableObject {
  var authState: AuthState { get }
  var errorMessage: String { get }
  var email: String { get set }
  var password: String { get set }
  var confirmPassword: String { get set }
  var flow: AuthFlow { get set }
  var isValid: Bool { get }
  
  func handleSignInWithApple(_ request: ASAuthorizationAppleIDRequest)
  
  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>)
  
  func signInWithEmailPassword() async -> Bool
  
  func signUpWithEmailPassword() async -> Bool
  
  func switchFlow()
  
  func reset()
}


@MainActor
final class RealAuthViewModel: AuthViewModel {
  let authService: AuthenticationService
  
//  private var cancellables = Set<AnyCancellable>()
  
  @Published var authState: AuthState
  @Published var errorMessage: String
  
  @Published var email = ""
  @Published var password = ""
  @Published var confirmPassword = ""
  
  @Published var flow: AuthFlow = .login
  
  @Published var isValid  = false
  
  init(authService: AuthenticationService, appState: AppState) {
    self.authService = authService
    self.authState = appState.userData.authState
    self.errorMessage = appState.userData.authError
    bindToAppState(appState: appState)
    makeIsValidPublisher()
  }
  
  private func bindToAppState(appState: AppState) {
    appState.$userData
      .map { $0.authState }
      .assign(to: &$authState)
    appState.$userData
      .map { $0.authError }
      .assign(to: &$errorMessage)
  }
  
//  private func bindAppState(appState: AppState) {
//    appState.$userData
//      .receive(on: RunLoop.main)
//      .sink { [weak self] userData in
//        self?.authState = userData.authState
//        self?.errorMessage = userData.authError
//      }
//      .store(in: &cancellables)
//  }
  
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

extension RealAuthViewModel {
  func signInWithEmailPassword() async -> Bool {
    await authService.signInWithEmailPassword(email: self.email, password: self.password)
  }
  
  func signUpWithEmailPassword() async -> Bool {
    await authService.signUpWithEmailPassword(email: self.email, password: self.password)
  }
  
  func handleSignInWithApple(_ request: ASAuthorizationAppleIDRequest) {
    authService.handleSignInWithAppleRequest(request)
  }
  
  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
    authService.handleSignInWithAppleCompletion(result)
  }
}

//MARK: - StubAuthViewModel
@MainActor
final class StubAuthViewModel: AuthViewModel {
  @Published var authState: AuthState = .unauthenticated
  @Published var errorMessage: String = ""
  @Published var email: String = ""
  @Published var password: String = ""
  @Published var confirmPassword: String = ""
  @Published var flow: AuthFlow = .login
  @Published var isValid: Bool = false
  
  func signInWithEmailPassword() async -> Bool {
    self.authState = .authenticated
    return true
  }
  
  func signUpWithEmailPassword() async -> Bool {
    self.authState = .authenticated
    return true
  }
  
  //note: empty implement. doesn't prevent the auth request from being sent
  func handleSignInWithApple(_ request: ASAuthorizationAppleIDRequest) {}
  
  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
    self.authState = .authenticated
  }
  
  func switchFlow() {
    flow = flow == .login ? .signUp : .login
  }
  
  func reset() {
    email = ""
    password = ""
    confirmPassword = ""
    
    flow = .login
  }
}


