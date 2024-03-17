//
//  SignupView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 10/02/2024.
//

import SwiftUI

private enum FocusableField {
  case email
  case password
  case confirmPassword
}

struct SignupView<ViewModel: AuthViewModel>: View {
  @EnvironmentObject var viewModel: ViewModel
  @Environment(\.dismiss) var dismiss

  @FocusState private var focus: FocusableField?
  
  private func signUpWithEmailPassword() {
    Task {
      if await viewModel.signUpWithEmailPassword() == true {
        dismiss()
      }
    }
  }
  
  var body: some View {
    VStack {
      Text("Sign up")
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
          .submitLabel(.next)
          .onSubmit {
            self.focus = .confirmPassword
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 8)
      
      HStack {
        Image(systemName: "lock")
        SecureField("Confirm password", text: $viewModel.confirmPassword)
          .focused($focus, equals: .confirmPassword)
          .submitLabel(.go)
          .onSubmit {
            signUpWithEmailPassword()
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 8)
      
      if !viewModel.errorMessage.isEmpty {
        VStack {
          Text(viewModel.errorMessage)
            .foregroundColor(Color(UIColor.systemRed))
        }
      }

      Button(action: signUpWithEmailPassword) {
        if viewModel.authState != .authenticating {
          Text("Sign up")
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
        Text("Already have an account?")
        Button(action: { viewModel.switchFlow() }) {
          Text("Log in")
            .fontWeight(.semibold)
            .foregroundColor(.blue)
        }
      }
      .padding([.top, .bottom], 50)
    }
  }
}

#Preview {
    SignupView<StubAuthViewModel>()
    .environmentObject(StubAuthViewModel())
}
