//
//  TextEditorExample.swift
//  MyChat
//
//  Created by Nikita Ivanov on 25/03/2024.
//

import SwiftUI

struct TextEditorExample: View {
  @State private var messageText: String = ""
      // Initial and max height for the TextEditor
      private let minHeight: CGFloat = 40
      private let maxHeight: CGFloat = 100
      @State private var editorHeight: CGFloat = 40 // Initial height

      var body: some View {
          VStack {
              Spacer() // Pushes everything to the bottom
              ZStack {
                  // Placeholder
                  if messageText.isEmpty {
                      Text("Type your message...")
                          .foregroundColor(.gray)
                          .padding(.leading, 5)
                          .frame(maxWidth: .infinity, alignment: .leading)
                  }
                  TextEditor(text: $messageText)
                      .frame(minHeight: minHeight, maxHeight: editorHeight)
                      .padding(4)
                      .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
                      .onChange(of: messageText) { _ in
                          // Adjust the height based on content, up to a max height
                          editorHeight = min(maxHeight, calculateTextHeight())
                      }
              }
              .padding()
          }
          .background(Color(.systemBackground))
          // Additional padding for safe area
          .edgesIgnoringSafeArea(.bottom)
      }
      
      // Function to calculate dynamic height based on text content
      private func calculateTextHeight() -> CGFloat {
          let textView = UITextView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: CGFloat.greatestFiniteMagnitude))
          textView.text = messageText
          textView.font = UIFont.systemFont(ofSize: 18)
          textView.sizeToFit()
          return textView.frame.height
      }
  }


