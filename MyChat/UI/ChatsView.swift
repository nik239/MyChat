//
//  ChatsView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 10/02/2024.
//

import SwiftUI

struct ChatsView: View {
  @EnvironmentObject private var viewModel: ChatsViewModel
  var body: some View {
    ScrollView(.vertical) {
      ForEach(viewModel.chats ?? []) { chat in
        ChatPreview(name: chat.name,
                    date: viewModel.lastMessageDate(chat: chat),
                    messagePreview: viewModel.messagePreview(chat: chat))
        Divider()
      }
    }
  }
}

#if DEBUG
#Preview {
  ChatsView()
    .inject(.preview)
}
#endif
