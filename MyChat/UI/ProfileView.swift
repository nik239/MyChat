//
//  ProfileView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 08/03/2024.
//

import SwiftUI

struct ProfileView: View {
  @EnvironmentObject var viewModel: ProfileViewModel
  
  //Using isEdditing for both focus and if/else doesn't work, because
  //TextField is not a part of the view hierarchy when isEditing is set true
  //so SwiftUI can't focus on it and resets focus to false
  @FocusState private var isEditing: Bool
  @State private var isTextField = false
  @State var showAlert = false
  
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
        if isTextField {
          TextField("Username", text: $viewModel.userHandle)
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .multilineTextAlignment(.center)
            .focused($isEditing)
            .onSubmit {
              isTextField = false
              viewModel.updateUserHandle()
            }
        } else {
          Text(viewModel.userHandle)
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        }
        Spacer()
      }
      
      Button(action: {
        isEditing = true
        isTextField = true
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
      
      Button(action: { showAlert = true }) {
        Text("Delete account?")
          .foregroundColor(.red)
      }
      .padding()
      
      Spacer()
      Divider()
    }
    .onAppear {
      viewModel.subscribeToState()
    }
    .onDisappear {
      viewModel.unsubscribeFromState()
    }
    .alert(isPresented: $showAlert) {
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
