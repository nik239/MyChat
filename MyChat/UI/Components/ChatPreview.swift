//
//  ChatView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 08/03/2024.
//

import SwiftUI

struct ChatPreview: View {
  let name: String
  let date: String
  let messagePreview: String
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        Text(name)
          .font(.headline)
          .foregroundColor(.primary)
          .lineLimit(1)
        Spacer()
        Text(date)
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      Text(messagePreview)
        .font(.subheadline)
        .foregroundColor(.secondary)
        .lineLimit(2)
        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
    }
    .padding()
  }
}

#Preview {
  ChatPreview(name: "Jessie P", date: "Yesterday", messagePreview: "Yo, Mr.White, let's cook")
}
