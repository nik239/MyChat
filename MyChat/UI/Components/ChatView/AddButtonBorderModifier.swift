//
//  ButtonBorderModifier.swift
//  MyChat
//
//  Created by Nikita Ivanov on 24/03/2024.
//

import SwiftUI

struct AddButtonBorder: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding()
      .background(Color.secondary.opacity(0.2))
      .cornerRadius(10)
  }
}

