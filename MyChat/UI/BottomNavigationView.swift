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
    TabView {
      ChatsView()
        .tabItem {
          Image(systemName: "message")
          Text("Home")
        }
        .toolbar(viewModel.showBottomNavigation ? .visible : .hidden, for: .tabBar)
      
      ProfileView()
        .tabItem {
          Image(systemName: "gear")
          Text("Settings")
        }
    }
    .onAppear {
      viewModel.subscribeToState()
    }
    .onDisappear {
      viewModel.unsubscribeFromState()
    }
  }
}

#Preview {
    BottomNavigationView()
    .inject(.preview)
}
