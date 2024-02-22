//
//  LoginView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 10/02/2024.
//

import SwiftUI

private enum FocusableField {
  case email
  case password
}

struct LoginView: View {
  @EnvironmentObject var viewModel: AuthViewModel
  @Environment(\.dismiss) var dismiss
  
  @FocusState private var focus: FocusableField?
  
  private func signInWithEmailPassword() {
    Task {
      if await viewModel.signInWithEmailPassword() == true {
        dismiss()
      }
    }
  }
  
  var body: some View {
    VStack {
      Text("Login")
        .font(.largeTitle)
        .fontWeight(.bold)
        .frame(maxWidth: .infinity, alignment: .leading)
      HStack {
        Image(systemName: "at")
        TextField("Email", text: $viewModel.email)
          .textInputAutocapitalization(.never)
          .disableAutocorrection(true)
          .focused($focus, equals: .email)
          .submitLabel(.next)
          .onSubmit {
            self.focus = .password
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 4)
      
      HStack {
        Image(systemName: "lock")
        SecureField("Password", text: $viewModel.password)
          .focused($focus, equals: .password)
          .submitLabel(.go)
          .onSubmit {
            signInWithEmailPassword()
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 8)
    }
    
    if !viewModel.authService.errorMessage.isEmpty {
      VStack {
        Text(viewModel.authService.errorMessage)
          .foregroundColor(Color(UIColor.systemRed))
      }
    }
    
    Button(action: signInWithEmailPassword) {
      if viewModel.authService.authState != .authenticating {
        Text("Login")
          .padding(.vertical, 8)
          .frame(maxWidth: .infinity)
      }
      else {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: .white))
          .padding(.vertical, 8)
          .frame(maxWidth: .infinity)
      }
    }
    .disabled(!viewModel.isValid)
    .frame(maxWidth: .infinity)
    .buttonStyle(.borderedProminent)
    
    HStack {
      Text("Don't have an account yet?")
      Button(action: { viewModel.switchFlow() }) {
        Text("Sign up")
          .fontWeight(.semibold)
          .foregroundColor(.blue)
      }
    }
    .padding([.top, .bottom], 50)
  }
}

#Preview {
    LoginView()
}
