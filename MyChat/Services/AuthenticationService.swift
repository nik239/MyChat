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

protocol AuthenticationService: AnyObject {
  var user: User? { get }
  var displayName: String { get }

  var authState: AuthState { get }
  var errorMessage: String { get set }
  
  func signOut()
  func deleteAccount() async -> Bool
  
  func signInWithEmailPassword(email: String, password: String) async -> Bool
  func signUpWithEmailPassword(email: String, password: String) async -> Bool
  
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest)
  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>)
}

final class RealAuthenticationService: AuthenticationService {
  @Published var user: User?
  @Published var displayName = ""
  
  @Published var authState: AuthState = .unauthenticated
  @Published var errorMessage = ""
  
  private var currentNonce: String?
  
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
  
  func signOut() {
    do {
      try Auth.auth().signOut()
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
    }
  }
  
  func deleteAccount() async -> Bool {
    do {
      try await user?.delete()
      return true
    }
    catch {
      errorMessage = error.localizedDescription
      return false
    }
  }
}

// MARK: Email and Password Authentication

extension RealAuthenticationService {
  func signInWithEmailPassword(email: String, password: String) async -> Bool {
    authState = .authenticating
    do {
      try await Auth.auth().signIn(withEmail: email, password: password)
      return true
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
      authState = .unauthenticated
      return false
    }
  }
  
  func signUpWithEmailPassword(email: String, password: String) async -> Bool {
    authState = .authenticating
    do  {
      try await Auth.auth().createUser(withEmail: email, password: password)
      return true
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
      authState = .unauthenticated
      return false
    }
  }
}

// MARK: Sign in with Apple

extension RealAuthenticationService {
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
    request.requestedScopes = [.fullName, .email]
    let nonce = randomNonceString()
    currentNonce = nonce
    request.nonce = sha256(nonce)
  }
  
  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
    if case .failure(let failure) = result {
      errorMessage = failure.localizedDescription
    }
    else if case .success(let authorization) = result {
      if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        guard let nonce = currentNonce else {
          fatalError("Invalid state: a login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
          print("Unable to fetdch identify token.")
          return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
          return
        }

        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        Task {
          do {
            let result = try await Auth.auth().signIn(with: credential)
            await updateDisplayName(for: result.user, with: appleIDCredential)
          }
          catch {
            print("Error authenticating: \(error.localizedDescription)")
          }
        }
      }
    }
  }
  
  func updateDisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) async {
    if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
      // current user is non-empty, don't overwrite it
    }
    else {
      let changeRequest = user.createProfileChangeRequest()
      changeRequest.displayName = appleIDCredential.displayName()
      do {
        try await changeRequest.commitChanges()
        self.displayName = Auth.auth().currentUser?.displayName ?? ""
      }
      catch {
        print("Unable to update the user's displayname: \(error.localizedDescription)")
        errorMessage = error.localizedDescription
      }
    }
  }
}

extension ASAuthorizationAppleIDCredential {
  func displayName() -> String {
    return [self.fullName?.givenName, self.fullName?.familyName]
      .compactMap( {$0})
      .joined(separator: " ")
  }
}
