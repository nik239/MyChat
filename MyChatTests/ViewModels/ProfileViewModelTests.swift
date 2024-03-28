//
//  ProfileViewModel.swift
//  MyChatTests
//
//  Created by Nikita Ivanov on 28/03/2024.
//

import XCTest
import FirebaseAuth
@testable import MyChat

final class ProfileViewModelTests: XCTestCase {
  private var viewModel: ProfileViewModel!
  
  @MainActor
  override func setUpWithError() throws {
    try super.setUpWithError()
    viewModel = ProfileViewModel(authService: MockedAuthService(), appState: AppState())
  }
  
  
}
