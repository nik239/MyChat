//
//  CreateChatButton.swift
//  MyChat
//
//  Created by Nikita Ivanov on 12/04/2024.
//

import SwiftUI

struct CreateChatButton: View {
  let createChat: () -> ()
    var body: some View {
      Button(action: createChat) {
        HStack{
          Text("Create!")
            .bold()
            .foregroundColor(.white)
          Image(systemName: "paperplane.circle.fill")
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
  CreateChatButton(createChat: {})
}
#endif
