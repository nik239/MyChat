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
  var body: some View {
    VStack(alignment: .center) {
      Image(systemName: "person.crop.circle")
        .resizable()
        .scaledToFit()
        .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.25, alignment: .center)
        .padding(.bottom, -30)
      
      HStack() {
        Spacer()
        if isEditing {
          TextField("Username", text: $viewModel.userHandle)
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .multilineTextAlignment(.center)
            .focused($isEditing)
        } else {
          Text(viewModel.userHandle)
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        }
        Spacer()
      }
      
      Button(action: {isEditing = true}) {
        Text("Change username")
          .foregroundColor(.green)
      }
    }
  }
}

#if DEBUG
#Preview {
    ProfileView()
    .inject(.preview)
}
#endif
