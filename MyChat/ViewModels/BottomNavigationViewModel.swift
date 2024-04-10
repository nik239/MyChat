//
//  BottomNavigationViewModel.swift
//  MyChat
//
//  Created by Nikita Ivanov on 24/03/2024.
//

import SwiftUI
import Combine

@MainActor
final class BottomNavigationViewModel: ObservableObject {
  @Published var showBottomNavigation: Bool = true
  @Published var userNameIsNil: Bool = true
  
  let appState: AppState
  var appStateSubs = Set<AnyCancellable>()
  
  nonisolated init(appState: AppState) {
    self.appState = appState
  }
  
  func subscribeToState() {
    appState.$routing
      .map { $0.showBottomNavigation }
      .removeDuplicates()
      .sink { self.showBottomNavigation = $0 }
      .store(in: &appStateSubs)
    appState.$userData
      .map { $0.user?.displayName }
      .removeDuplicates()
      .sink { self.userNameIsNil = $0 == nil }
      .store(in: &appStateSubs)
  }
  
  func unsubscribeFromState() {
    appStateSubs.removeAll()
    appStateSubs = Set<AnyCancellable>()
  }
}

