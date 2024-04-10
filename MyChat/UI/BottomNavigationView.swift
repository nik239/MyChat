//
//  TabView.swift
//  MyChat
//
//  Created by Nikita Ivanov on 20/03/2024.
//

import SwiftUI

struct BottomNavigationView: View {
  @EnvironmentObject var viewModel: BottomNavigationViewModel
  
  #if DEBUG
  let inspection = Inspection<Self>()
  #endif
  
  var body: some View {
    TabView {
      ChatsView()
        .tabItem {
          Image(systemName: "message")
        }
        .toolbar(viewModel.showBottomNavigation ? .visible : .hidden, for: .tabBar)
      
      ProfileView()
        .tabItem {
          Image(systemName: "gear")
        }
    }
    .onAppear {
      viewModel.subscribeToState()
    }
    .onDisappear {
      viewModel.unsubscribeFromState()
    }
    .fullScreenCover(isPresented: $viewModel.userNameIsNil) {
      SetUsernameView()
    }
    #if DEBUG
    .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    #endif
  }
}

#if DEBUG
#Preview {
    BottomNavigationView()
    .inject(.preview)
}
#endif
