//
//  CreateChatView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 08/03/2024.
//

import SwiftUI

struct CreateChatView: View {
  @State var isValid = true
  
  enum Field: Hashable {
    case name
    case members
  }
  
  @FocusState var focusField: Field?
  @State var addingMembers = false
  
  @State var memberEntry: String = ""
  @State var chatNameEntry: String = ""
  
  
  var body: some View {
    VStack (alignment: .leading) {
      HStack {
        Spacer()
        CreateChatButton(createChat: {})
        .padding()
      }
      Spacer()
      HStack {
        Text("Name:")
        TextField("(Optional)", text: $chatNameEntry)
          .focused($focusField, equals: .name)
          .onSubmit {
            focusField = .members
            addingMembers = true
          }
      }
      .padding()
      
      Text("Members: user1, user2, user3")
        .padding()
      HStack {
        
      }
      if addingMembers {
        HStack (alignment: .bottom) {
          TextField("Enter username", text: $memberEntry)
            .focused($focusField, equals: .members)
          Button(action: {print("adding member")}) {
            Image(systemName: "plus.circle")
              .resizable()
              .frame(width: 30, height: 30)
          }
          .tag("send button")
          .disabled(isValid)
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
    }
  }
}

#if DEBUG
#Preview {
  CreateChatView()
    .inject(.preview)
}
#endif
