//
//  File.swift
//  
//
//  Created by Nikita Ivanov on 24/04/2024.
//

import Foundation

final class TrieNode<T: Hashable> {
  var value: T?
  var isTerminating = false
  weak var parent: TrieNode?
  var children: [T: TrieNode] = [:]
  
  init(value: T? = nil, parent: TrieNode? = nil) {
    self.value = value
    self.parent = parent
  }
  
  func add(child: T) {
    guard children[child] == nil else { return }
    children[child] = TrieNode(value: child, parent: self)
  }
}
