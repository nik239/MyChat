//
//  ChatsView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 10/02/2024.
//

import SwiftUI

struct ChatsView: View {
  @EnvironmentObject private var viewModel: ChatsViewModel
  
  #if DEBUG
  let inspection = Inspection<Self>()
  #endif
  
  var body: some View {
    NavigationStack {
      VStack (alignment: .leading) {
        HStack {
          Spacer()
          AddChatButton(createChat: viewModel.didTapAddBtn)
            .padding(5)
        }
        Spacer()
        ScrollView(.vertical) {
          ForEach(viewModel.chats ?? []) { chat in
            ChatPreview(name: chat.name,
                        date: viewModel.lastMessageDate(chat: chat),
                        messagePreview: viewModel.messagePreview(chat: chat))
            .onTapGesture {
              viewModel.didTapOnChat(chat: chat)
            }
            Divider()
          }
        }
      }
      .navigationDestination(isPresented: $viewModel.showChatView) {
        ChatView()
      }
      Spacer()
    }
    .sheet(isPresented: $viewModel.showingCreateChat) {
      CreateChatView()
    }
    .onAppear {
      viewModel.subscribeToState()
    }
    .onDisappear {
      viewModel.unsubscribeFromState()
    }
    #if DEBUG
    .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    #endif
  }
}

#if DEBUG
#Preview {
  ChatsView()
    .inject(.preview)
}
#endif
