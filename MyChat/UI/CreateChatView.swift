//
//  CreateChatView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 08/03/2024.
//

import SwiftUI

struct CreateChatView: View {
  @EnvironmentObject var viewModel: CreateChatViewModel
  
  @FocusState var focused: Bool
  
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
        Text("Chat Name:")
        TextField("(Optional)", text: $viewModel.chatNameEntry)
          .focused($focused)
          .onSubmit {
            viewModel.addingMembers = true
          }
      }
      .padding()
      
      if viewModel.error != "" {
        Text(viewModel.error)
          .foregroundColor(.red)
      }
      
      if !viewModel.addingMembers {
        HStack {
          Spacer()
          Button(action: { viewModel.addingMembers = true}) {
            HStack{
              Text("Add members")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
              Image(systemName: "plus")
                .foregroundColor(.white)
                .font(.title2)
            }
            .padding(10)
            .background(.blue)
            .cornerRadius(10)
          }
          Spacer()
        }
      } else {
        SearchBar(text: $viewModel.searchText
            .onSet { _ in
              viewModel.reloadUsers()
            }
        )
        Spacer()
      }
      
//      Text("Members: " + viewModel.allMembers)
//        .padding()
//        .onTapGesture {
//          viewModel.addingMembers = true
//          focusField = .members
//        }
      
//      if viewModel.addingMembers {
//        HStack (alignment: .bottom) {
//          TextField("Enter username", text: $viewModel.memberEntry)
//            .focused($focusField, equals: .members)
//            .onSubmit {
//              viewModel.addingMembers = false
//            }
//          Button(action: viewModel.addMember) {
//            Image(systemName: "plus.circle")
//              .resizable()
//              .frame(width: 30, height: 30)
//          }
//        }
//        .padding(5)
//        .overlay(
//          RoundedRectangle(cornerRadius: 15)
//            .stroke(Color.secondary)
//        )
//        .padding()
//      }
      Spacer()
    }
    .onAppear() {
      focused = true
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
