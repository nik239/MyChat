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
  
  #if DEBUG
  let inspection = Inspection<Self>()
  #endif
  
  var body: some View {
    if viewModel.usernameState == .updating {
      ProgressView()
        .tag("progress")
    } else {
      VStack (alignment: .leading) {
        Text("Please come up with a unique username")
          .font(.title)
          .foregroundColor(.cyan)
          .padding()
          .tag("prompt")
        TextField("username...", text: $viewModel.userEntry)
          .font(.title)
          .multilineTextAlignment(.leading)
          .padding([.leading,.trailing])
          .focused($isEditing)
          .onSubmit {
            viewModel.setUsername()
          }
          .tag("username field")
        if viewModel.usernameState == .error {
          Text(viewModel.error)
            .foregroundColor(.red)
            .padding()
            .tag("error")
        }
      }
      .onAppear() {
        isEditing = true
        viewModel.subscribeToState()
      }
      .onDisappear() {
        viewModel.unsubscribeFromState()
      }
      #if DEBUG
      .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
      #endif
    }
  }
}

#Preview {
  SetUsernameView()
    .inject(.preview)
}
