//
//  CredentialsView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 10/02/2024.
//

import SwiftUI

struct CredentialsView: View {
  @EnvironmentObject var model: AuthViewModel
  
  var body: some View {
    switch model.flow {
    case .login:
      LoginView()
        .environmentObject(model)
    case .signUp:
      SignupView()
        .environmentObject(model)
    }
  }
}

#Preview {
    CredentialsView()
}
