//
//  ChatView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 18/03/2024.
//

import SwiftUI

struct ChatView: View {
  @EnvironmentObject private var viewModel: ChatViewModel
  var body: some View {
    VStack {
      ScrollView(.vertical){
        ForEach(viewModel.messages ?? []) { message in
          HStack {
            if viewModel.isAuthorSelf(message: message) {
              Spacer()
              MessageBubble(message: message)
              .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .trailing)
              .padding()
            } else {
              MessageBubble(message: message)
              .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .leading)
              .padding([.leading, .trailing])
              Spacer()
            }
          }
        }
      }
      HStack {
        TextField("Message", text: $viewModel.newMessageContent)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding()
        
        Button(action: viewModel.sendMessage) {
          Image(systemName: "arrow.up.circle.fill")
            .resizable()
            .frame(width: 44, height: 44)
            .padding(.trailing)
        }
        .disabled(viewModel.newMessageContent.isEmpty)
      }
      //.background(Color.secondarySystemBackground)
      //.padding(.bottom, keyboardHeight())
    }
  }
}

#if DEBUG
#Preview {
  ChatView()
    .inject(.preview)
}
#endif
