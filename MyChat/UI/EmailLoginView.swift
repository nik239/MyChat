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
  
  @FocusState private var focus: FocusableField?
  
  #if DEBUG
  let inspection = Inspection<Self>()
  #endif
  
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
            viewModel.signInWithEmailPassword()
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 8)
    }
    
    if !viewModel.errorMessage.isEmpty {
      VStack {
        Text(viewModel.errorMessage)
          .foregroundColor(Color(UIColor.systemRed))
      }
    }
    
    Button(action: viewModel.signInWithEmailPassword) {
      if viewModel.authState != .authenticating {
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
    #if DEBUG
    .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    #endif
  }
}

#if DEBUG
#Preview {
    LoginView()
      .inject(.preview)
}
#endif
