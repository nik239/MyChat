//
//  ContentView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 10/03/2024.
//

import SwiftUI
import Combine

struct ContentView: View {
  private let container: DIContainer
  private let  isRunningTests: Bool
  
  init(container: DIContainer, isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests) {
    self.container = container
    self.isRunningTests = isRunningTests
  }
    var body: some View {
      if isRunningTests {
        Text("Running unit tests")
      } else {
        AuthView() {
          ChatsView()
        }
        .inject(container)
      }
    }
}

#if DEBUG
#Preview {
  ContentView(container: .preview)
}
#endif
