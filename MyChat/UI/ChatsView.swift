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
        Text("This view will display your chats!")
    }
}

#Preview {
    ChatsView()
}
