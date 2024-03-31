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
  
  init(appState: AppState) {
    appState.$routing
      .map {
        return $0.showBottomNavigation
      }
      .removeDuplicates()
      .assign(to: &$showBottomNavigation)
  }
}

