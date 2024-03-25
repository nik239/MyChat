//
//  TabView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 20/03/2024.
//

import SwiftUI

struct BottomNavigationView: View {
  @EnvironmentObject private var viewModel: BottomNavigationViewModel
  var body: some View {
    if viewModel.showBottomNavigation {
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
    } else {
      ChatsView()
    }
  }
}

#Preview {
    BottomNavigationView()
    .inject(.preview)
}
