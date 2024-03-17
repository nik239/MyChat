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
  func signOut()
  func deleteAccount() async -> Bool
  
  func clearError()
  
  func signInWithEmailPassword(email: String, password: String) async -> Bool
  func signUpWithEmailPassword(email: String, password: String) async -> Bool
  
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest)
  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>)
}

final class RealAuthenticationService: AuthenticationService {
  let appState: AppState
  
  private var currentNonce: String?
  
  private var authStateHandler: AuthStateDidChangeListenerHandle?
  
  init(appState: AppState) {
    self.appState = appState
    registerAuthStateHandler()
  }
  
  private func registerAuthStateHandler() {
    if authStateHandler == nil {
      authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
        self.appState.update(user: user)
        self.appState.update(authState: user == nil ? .unauthenticated : .authenticated)
      }
    }
  }
  
  func signOut() {
    do {
      try Auth.auth().signOut()
    }
    catch {
      print(error)
      self.appState.update(authError: error.localizedDescription)
    }
  }
  
  func deleteAccount() async -> Bool {
    do {
      try await self.appState.userData.user?.delete()
      return true
    }
    catch {
      self.appState.update(authError: error.localizedDescription)
      return false
    }
  }
  
  func clearError() {
    self.appState.update(authError: "")
  }
}

// MARK: Email and Password Authentication
extension RealAuthenticationService {
  func signInWithEmailPassword(email: String, password: String) async -> Bool {
    self.appState.update(authState: .authenticating)
    do {
      try await Auth.auth().signIn(withEmail: email, password: password)
      return true
    }
    catch {
      print(error)
      self.appState.update(authError: error.localizedDescription)
      self.appState.update(authState: .unauthenticated)
      return false
    }
  }
  
  func signUpWithEmailPassword(email: String, password: String) async -> Bool {
    self.appState.update(authState: .authenticating)
    do  {
      try await Auth.auth().createUser(withEmail: email, password: password)
      return true
    }
    catch {
      print(error)
      self.appState.update(authError: error.localizedDescription)
      self.appState.update(authState: .unauthenticated)
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
      self.appState.update(authError: failure.localizedDescription)
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
           // await updateDisplayName(for: result.user, with: appleIDCredential)
          }
          catch {
            print("Error authenticating: \(error.localizedDescription)")
          }
        }
      }
    }
  }
  
//  func updateDisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) async {
//    if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
//      // current user is non-empty, don't overwrite it
//    }
//    else {
//      let changeRequest = user.createProfileChangeRequest()
//      changeRequest.displayName = appleIDCredential.displayName()
//      do {
//        try await changeRequest.commitChanges()
//        self.displayName = Auth.auth().currentUser?.displayName ?? ""
//      }
//      catch {
//        print("Unable to update the user's displayname: \(error.localizedDescription)")
//        errorMessage = error.localizedDescription
//      }
//    }
//  }
}

//extension ASAuthorizationAppleIDCredential {
//  func displayName() -> String {
//    return [self.fullName?.givenName, self.fullName?.familyName]
//      .compactMap( {$0})
//      .joined(separator: " ")
//  }
//}
