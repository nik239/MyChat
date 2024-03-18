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
          
        }
      }
      Text("")
    }
  }
}

#if DEBUG
#Preview {
  ChatView()
}
#endif
