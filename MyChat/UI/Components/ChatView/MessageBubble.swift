//
//  MessageBubble.swift
//  MyChat
//
//  Created by Nikita Ivanov on 18/03/2024.
//

import SwiftUI

struct MessageBubble: View {
  let message: Message
    var body: some View {
        Text(message.content)
        .padding()
        .background(.secondary)
        .foregroundColor(.primary)
        .cornerRadius(30)
        .shadow(radius: 3)
    }
}

#Preview {
  MessageBubble(message: Message(author: "Frodo", content: "Hey, what's up?"))
}
