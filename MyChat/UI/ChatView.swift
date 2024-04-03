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
      HStack {
        Text(viewModel.chatName ?? "")
          .font(.title2)
      }
      .padding(.bottom)
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
      HStack (alignment: .bottom) {
          TextEditor(text: $viewModel.userInput)
          .font(viewModel.editorFont)
          .frame(minWidth: viewModel.editorWidth,
                 maxWidth: viewModel.editorWidth,
                 maxHeight: viewModel.editorHeight)
        
          .onChange(of: viewModel.userInput, initial: false) {
              viewModel.editorHeight = min(viewModel.maxHeight, viewModel.calculateTextHeight())
            }
        
        Button(action: viewModel.sendMessage) {
          Image(systemName: "arrow.up.circle.fill")
            .resizable()
            .frame(width: 30, height: 30)
        }
        .disabled(viewModel.userInput.isEmpty)
      }
      .padding(5)
      .overlay(
        RoundedRectangle(cornerRadius: 15)
          .stroke(Color.secondary)
      )
      .padding()
    }
    .onAppear {
      viewModel.preformOnAppear()
    }
    .onDisappear {
      viewModel.preformOnDisappear()
    }
  }
}

#if DEBUG
#Preview {
  ChatView()
    .inject(.preview)
}
#endif
