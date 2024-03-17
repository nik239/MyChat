//
//  ChatsView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 10/02/2024.
//

import SwiftUI

struct ChatsView<ViewModel: ChatsViewModel>: View {
  @EnvironmentObject private var viewModel: ViewModel
    var body: some View {
      ScrollView(.vertical) {
        ForEach(viewModel.chats ?? []) { chat in
          ChatPreview(name: chat.name, date: "Today", messagePreview: "Yo, Mr white")
        }
      }
    }
}

#Preview {
  ChatsView<StubChatsViewModel>()
    .environmentObject(StubChatsViewModel())
}
