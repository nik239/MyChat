//
//  ProfileView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 08/03/2024.
//

import SwiftUI

struct ProfileView: View {
  @EnvironmentObject var viewModel: ProfileViewModel
  @FocusState private var isEditing: Bool
  
  #if DEBUG
  let inspection = Inspection<Self>()
  #endif
  
  var body: some View {
    VStack(alignment: .center) {
      Spacer()
      Spacer()
      Image(systemName: "person.crop.circle")
        .resizable()
        .scaledToFit()
        .frame(width: UIScreen.main.bounds.width * 0.25,
               height: UIScreen.main.bounds.height * 0.25,
               alignment: .center)
        .padding(.bottom, -50)
      
      HStack() {
        Spacer()
        switch viewModel.usernameState {
        case .notSet:
          TextField("Username", text: $viewModel.username)
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .multilineTextAlignment(.center)
            .focused($isEditing)
            .onSubmit {
              viewModel.setUserName()
            }
        case .updating:
          ProgressView()
        case .set, .error:
          Text(viewModel.username)
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        }
        Spacer()
      }
      
      if viewModel.error != "" {
        Text(viewModel.error)
          .foregroundColor(.red)
          .padding()
      }
      
      Button(action: {
        isEditing = true
        viewModel.usernameState = .notSet
      }) {
        Text("Change username")
          .foregroundColor(.green)
      }
      .modifier(AddButtonBorder())
      
      Button(action: { viewModel.signOut() }) {
        Text("Sign out")
          .foregroundColor(.blue)
      }
      .modifier(AddButtonBorder())
      
      Spacer()
      
      Button(action: { viewModel.showAlert = true }) {
        Text("Delete account?")
          .foregroundColor(.red)
      }
      .padding()
      
      Spacer()
    }
    .onAppear {
      viewModel.subscribeToState()
    }
    .onDisappear {
      viewModel.unsubscribeFromState()
    }
    .alert(isPresented: $viewModel.showAlert) {
      Alert(
        title: Text("Confirm Deletion"),
        message: Text("Are you sure you want to delete your account?"),
        primaryButton: .destructive(Text("Confirm")) {
          viewModel.deleteAccount()
        },
        secondaryButton: .cancel {}
      )
    }
    #if DEBUG
    .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    #endif
  }
}

#if DEBUG
#Preview {
    ProfileView()
    .inject(.preview)
}
#endif
