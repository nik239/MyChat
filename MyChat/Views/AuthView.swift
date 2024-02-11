//
//  ContentView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 05/02/2024.
//

import SwiftUI

struct AuthView <Content : View> : View {
  @StateObject private var model = AuthViewModel()
  @State private var presentingCredentialsView = false
  
  @ViewBuilder var content: () -> Content
  
  var body: some View {
    switch model.authStatus {
    case .unauthenticated, .authenticating:
      VStack {
        Text("Welcome to MyChat!")
        Button(action: {
          model.reset()
          presentingCredentialsView.toggle()
        }, label: {
          Text("Log In")
            .foregroundColor(.cyan)
        })
      }
      .sheet(isPresented: $presentingCredentialsView) {
        
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
