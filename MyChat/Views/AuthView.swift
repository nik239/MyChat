//
//  ContentView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 05/02/2024.
//

import SwiftUI
import AuthenticationServices

struct AuthView <Content : View> : View {
  @Environment(\.colorScheme) var colorScheme
  
  @StateObject private var viewModel = AuthViewModel()
  @State private var presentingCredentialsView = false
  
  @ViewBuilder var content: () -> Content
  
  var body: some View {
    switch viewModel.authState {
    case .unauthenticated, .authenticating:
      VStack {
        Text("Welcome to MyChat!")
          .font(.title)
        
        SignInWithAppleButton(.signIn) { request in
          viewModel.handleSignInWithAppleRequest(request)
        } onCompletion: { result in
          viewModel.handleSignInWithAppleCompletion(result)
        }
        .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
        .frame(maxWidth: 300, maxHeight: 50)
        .cornerRadius(8)
        
        Button(action: {
          viewModel.reset()
          presentingCredentialsView.toggle()
        }, label: {
          Text("Continue with email and password")
            .foregroundColor(.cyan)
        })
        .frame(maxWidth: 300, maxHeight: 50)
        .cornerRadius(8)
      }
      .sheet(isPresented: $presentingCredentialsView) {
        switch viewModel.flow {
        case .login:
          LoginView()
            .environmentObject(viewModel)
        case .signUp:
          SignupView()
            .environmentObject(viewModel)
        }
      }
    case .authenticated:
      content()
    }
  }
}

#Preview {
  AuthView() {
    Text("Chats View")
  }
}
