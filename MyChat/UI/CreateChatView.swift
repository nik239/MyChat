//
//  CreateChatView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 08/03/2024.
//

import SwiftUI

struct CreateChatView: View {
  @EnvironmentObject var viewModel: CreateChatViewModel
  
  enum Field: Hashable {
    case name
    case members
  }
  
  @FocusState var focusField: Field?
  
  var body: some View {
    VStack (alignment: .leading) {
      HStack {
        Spacer()
        CreateChatButton(createChat: viewModel.createChat,
                         isDisabled: viewModel.isValid)
        .disabled(viewModel.isValid)
        .padding()
      }
      Spacer()
      HStack {
        Text("Name:")
        TextField("(Optional)", text: $viewModel.chatNameEntry)
          .focused($focusField, equals: .name)
          .onSubmit {
            focusField = .members
            viewModel.addingMembers = true
          }
      }
      .padding()
      
      Text("Members: " + viewModel.allMembers)
        .padding()
        .onTapGesture {
          viewModel.addingMembers = true
          focusField = .members
        }
      
      if viewModel.error != "" {
        Text(viewModel.error)
          .foregroundColor(.red)
      }
      
      if viewModel.addingMembers {
        HStack (alignment: .bottom) {
          TextField("Enter username", text: $viewModel.memberEntry)
            .focused($focusField, equals: .members)
            .onSubmit {
              viewModel.addingMembers = false
            }
          Button(action: viewModel.addMember) {
            Image(systemName: "plus.circle")
              .resizable()
              .frame(width: 30, height: 30)
          }
        }
        .padding(5)
        .overlay(
          RoundedRectangle(cornerRadius: 15)
            .stroke(Color.secondary)
        )
        .padding()
      }
      Spacer()
    }
    .onAppear() {
      focusField = .name
      viewModel.subscribeToState()
    }
    .onDisappear() {
      viewModel.preformOnDisappear()
    }
  }
}

#if DEBUG
#Preview {
  CreateChatView()
    .inject(.preview)
}
#endif
