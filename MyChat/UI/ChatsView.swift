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
    NavigationView {
      VStack (alignment: .leading) {
        ScrollView(.vertical) {
          ForEach(viewModel.chats ?? []) { chat in
            NavigationLink(destination: ChatView()) {
              ChatPreview(name: chat.name,
                          date: viewModel.lastMessageDate(chat: chat),
                          messagePreview: viewModel.messagePreview(chat: chat))
            }
            .simultaneousGesture(TapGesture().onEnded {
              viewModel.didTapOnChat(chat: chat)
            })
            Divider()
          }
        }
      }
    }
    .sheet(isPresented: $viewModel.showingCreateChat) {
      CreateChatView()
    }
    .navigationBarTitle("Chats")
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
