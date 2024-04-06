//
//  MockedServices.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 25/03/2024.
//

import XCTest
@testable import MyChat
import AuthenticationServices

final class MockedAuthService: Mock, AuthService {
  enum Action: Equatable {
    case signInWithEmailPassword(email: String, password: String)
    case signUpWithEmailPassword(email: String, password: String)
    //case handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest)
    //case handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>)
    case signOut
    case deleteAccount
    case changeUserHandle(newUserHandle: String)
    case clearError
  }
  
  var actions: MockActions<Action>
  
  init(expected: [Action] = []) {
    self.actions = .init(expected: expected)
  }
  
  func signInWithEmailPassword(email: String, password: String) {
    register(.signInWithEmailPassword(email: email, password: password))
  }
  
  func signUpWithEmailPassword(email: String, password: String) {
    register(.signUpWithEmailPassword(email: email, password: password))
  }
  
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {}
  
  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {}
  
  func signOut() {
    register(.signOut)
  }
  
  func deleteAccount() {
    register(.deleteAccount)
  }
  
  func changeDisplayName(newName: String) {
    register(.changeUserHandle(newUserHandle: newName))
  }
  
  func clearError() {
    register(.clearError)
  }
}
