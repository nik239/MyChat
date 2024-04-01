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
  
  let appState: AppState
  var appStateSub: AnyCancellable?
  
  nonisolated init(appState: AppState) {
    self.appState = appState
  }
  
  func subscribeToState() {
    appStateSub = appState.$routing
    .map { $0.showBottomNavigation }
    .removeDuplicates()
    .sink { self.showBottomNavigation = $0 }
  }
  
  func unsubscribeFromState() {
    appStateSub?.cancel()
  }
}

