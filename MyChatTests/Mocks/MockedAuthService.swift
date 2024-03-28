//
//  MockedServices.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 25/03/2024.
//

import XCTest
@testable import MyChat
import AuthenticationServices

struct MockedAuthService: Mock, AuthService {
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
  
  let actions: MockActions<Action>
  
  init(expected: [Action] = []) {
    self.actions = .init(expected: expected)
  }
  
  func signInWithEmailPassword(email: String, password: String) async -> Bool {
    register(.signInWithEmailPassword(email: email, password: password))
    return true
  }
  
  func signUpWithEmailPassword(email: String, password: String) async -> Bool {
    register(.signUpWithEmailPassword(email: email, password: password))
    return true
  }
  
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {}
  
  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {}
  
  func signOut() {
    register(.signOut)
  }
  
  func deleteAccount() async -> Bool {
    register(.deleteAccount)
    return true
  }
  
  func changeUserHandle(newUserHandle: String) async {
    register(.changeUserHandle(newUserHandle: newUserHandle))
  }
  
  func clearError() {
    register(.clearError)
  }
}
