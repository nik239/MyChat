//
//  AddChatButton.swift
//  MyChat
//
//  Created by Nikita Ivanov on 13/04/2024.
//

import SwiftUI

struct AddChatButton: View {
  let createChat: () -> ()
    var body: some View {
      Button(action: createChat) {
        HStack{
          Text("new chat")
            .bold()
            .foregroundColor(.white)
          Image(systemName: "plus")
            .foregroundColor(.white)
        }
        .padding(10)
        .background(.blue)
        .cornerRadius(10)
      }
    }
}

#if DEBUG
#Preview {
  AddChatButton(createChat: {})
}
#endif
