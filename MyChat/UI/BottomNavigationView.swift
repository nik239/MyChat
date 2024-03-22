//
//  TabView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 20/03/2024.
//

import SwiftUI

struct BottomNavigationView: View {
  var body: some View {
    TabView {
      ChatsView()
        .tabItem {
          Image(systemName: "message")
          Text("Home")
        }
      
      ProfileView()
        .tabItem {
          Image(systemName: "gear")
          Text("Settings")
        }
    }
  }
}

#Preview {
    BottomNavigationView()
    .inject(.preview)
}
