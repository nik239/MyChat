//
//  AuthService.swift
//  MyChat
//
//  Created by Nikita Ivanov on 21/02/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFunctions
import AuthenticationServices

enum AuthState {
  case unauthenticated
  case authenticating
  case authenticated
}

// MARK: - AuthService
protocol AuthService {
  func signInWithEmailPassword(email: String, password: String) async
  func signUpWithEmailPassword(email: String, password: String) async
  
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest)
  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>)
  
  func signOut()
  func deleteAccount() async
  func setUsername(newName: String) async throws
  
  func clearError()
}
  
// MARK: -StubAuthService
final class StubAuthService: AuthService {
  
  func signInWithEmailPassword(email: String, password: String) { }
  
  func signUpWithEmailPassword(email: String, password: String) { }
  
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) { }
  
  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) { }
  
  func signOut() { }
  
  func deleteAccount()  { }
  
  func clearError() { }
  
  func setUsername(newName: String) { }
}
