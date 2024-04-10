//
//  SetUsernameView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 09/04/2024.
//

import SwiftUI

struct SetUsernameView: View {
  @EnvironmentObject var viewModel: UsernameViewModel
  @FocusState private var isEditing: Bool
  var body: some View {
    if viewModel.usernameState == .updating {
      ProgressView()
    } else {
      VStack (alignment: .leading) {
        Text("Please come up with a unique username")
          .font(.title)
          .foregroundColor(.cyan)
          .padding()
        TextField("username...", text: $viewModel.userEntry)
          .font(.title)
          .multilineTextAlignment(.leading)
          .padding([.leading,.trailing])
          .focused($isEditing)
          .onSubmit {
            viewModel.setUsername()
          }
        if viewModel.usernameState == .error {
          Text("Error")
            .foregroundColor(.red)
            .padding()
        }
      }
      .onAppear() {
        isEditing = true
        viewModel.subscribeToState()
      }
      .onDisappear() {
        viewModel.unsubscribeFromState()
      }
    }
  }
}

#Preview {
  SetUsernameView()
    .inject(.preview)
}
