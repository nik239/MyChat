//
//  ContentView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 05/02/2024.
//

import SwiftUI
import AuthenticationServices

struct AuthView <ViewModel: AuthViewModel,Content:View> : View {
  @Environment(\.colorScheme) var colorScheme
  
  @EnvironmentObject private var viewModel: ViewModel
  @State private var presentingCredentialsView = false
  
  @ViewBuilder var content: () -> Content
  
  var body: some View {
    switch viewModel.authState {
    case .unauthenticated, .authenticating:
      VStack {
        Text("Welcome to MyChat!")
          .font(.title)
        
        SignInWithAppleButton(.signIn) { request in
          viewModel.handleSignInWithApple(request)
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
          LoginView<RealAuthViewModel>()
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
  AuthView<StubAuthViewModel,Text> {
    Text("Chats View")
  }
  .environmentObject(StubAuthViewModel())
}
