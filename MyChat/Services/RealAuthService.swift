//
//  RealAuthService.swift
//  MyChat
//
//  Created by Nikita Ivanov on 09/04/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFunctions
import AuthenticationServices

final class RealAuthService: AuthService {
  let appState: AppState
  
  private var currentNonce: String?
  
  private var authStateHandler: AuthStateDidChangeListenerHandle?
  
  init(appState: AppState) {
    self.appState = appState
    createAuthStateHandler()
  }
  
  private func createAuthStateHandler() {
    if authStateHandler == nil {
      authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
        Task {
          await self.appState.update(authState: user == nil ? .unauthenticated : .authenticated)
          await self.appState.update(uid: user?.uid, username: user?.displayName)
        }
      }
    }
  }
  
  func signOut() {
    do {
      try Auth.auth().signOut()
    }
    catch {
      print(error)
      Task {
        await self.appState.update(error: error.localizedDescription)
      }
    }
  }
  
  func deleteAccount() async {
    do {
      try await Auth.auth().currentUser?.delete()
    }
    catch {
      Task {
        await self.appState.update(error: error.localizedDescription)
      }
    }
  }
  
  func clearError() {
    Task {
      await self.appState.update(error: nil)
    }
  }
}

// MARK: - RealAuthService Email and Password Authentication
extension RealAuthService {
  func signInWithEmailPassword(email: String, password: String) async {
    await self.appState.update(authState: .authenticating)
    do {
      try await Auth.auth().signIn(withEmail: email, password: password)
    }
    catch {
      print(error)
      await self.appState.update(error: error.localizedDescription)
      await self.appState.update(authState: .unauthenticated)
    }
  }
  
  func signUpWithEmailPassword(email: String, password: String) async {
    await self.appState.update(authState: .authenticating)
    do  {
      try await Auth.auth().createUser(withEmail: email, password: password)
    }
    catch {
      print(error)
      await self.appState.update(error: error.localizedDescription)
      await self.appState.update(authState: .unauthenticated)
    }
  }
}

// MARK: -RealAuthService Update username
extension RealAuthService {
  func setUsername(newName: String) async throws {
    guard let changeRequest = await Auth.auth().currentUser?.createProfileChangeRequest() else {
      return
    }
    changeRequest.displayName = newName
    do {
      try await requestFSupdate(newName: newName)
      // if .commitChanges throws after requestFSupdate succeeds, not good
      try await changeRequest.commitChanges()
    }
    catch {
      print("Unable to update the user's displayname: \(error.localizedDescription)")
      await self.appState.update(error: "\(error)")
      throw error
    }
  }
  
  /// Updates username in FireStore. Throws if the username is taken.
  /// Unfortunately, Firebase doesn't provide a straightforward way to trigger side-effects when a user changes their displayName.
  func requestFSupdate(newName: String) async throws {
    let _ : Void = try await withCheckedThrowingContinuation { continuation in
      let request = ["new_name": newName]
      Functions.functions().httpsCallable("updateDisplayName").call(request) { _, error in
        if let error = error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume()
        }
      }
    }
  }
}

// MARK: -RealAuthService Sign in with Apple
extension RealAuthService {
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
    request.requestedScopes = [.fullName, .email]
    let nonce = randomNonceString()
    currentNonce = nonce
    request.nonce = sha256(nonce)
  }
  
  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
    if case .failure(let failure) = result {
      Task {
        await self.appState.update(error: failure.localizedDescription)
      }
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
          }
          catch {
            print("Error authenticating: \(error.localizedDescription)")
          }
        }
      }
    }
  }
}

