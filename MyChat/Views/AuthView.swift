//
//  ContentView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 05/02/2024.
//

import SwiftUI

struct AuthView <Content : View> : View {
  @StateObject private var viewModel = AuthViewModel()
  @State private var presentingCredentialsView = false
  
  @ViewBuilder var content: () -> Content
  
  var body: some View {
    switch viewModel.authState {
    case .unauthenticated, .authenticating:
      VStack {
        Text("Welcome to MyChat!")
        Button(action: {
          viewModel.reset()
          presentingCredentialsView.toggle()
        }, label: {
          Text("Log In")
            .foregroundColor(.cyan)
        })
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
