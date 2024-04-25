//
//  File.swift
//  
//
//  Created by Nikita Ivanov on 23/04/2024.
//

import Foundation

final class PrefixTrie {
  typealias Node = TrieNode<Character>
  
  let root: Node
  
  init() {
    root = Node()
  }
}

extension PrefixTrie {
  func insert(word: String) {
    guard !word.isEmpty else { return }
    
    var currentNode = root
    
    let characters = Array(word)
    var currentIndex = 0
    
    while currentIndex < characters.count {
      let character = characters[currentIndex]

      if let child = currentNode.children[character] {
        currentNode = child
      } else {
        currentNode.add(child: character)
        currentNode = currentNode.children[character]!
      }
      
      currentIndex += 1

      if currentIndex == characters.count {
        currentNode.isTerminating = true
      }
    }
  }
  
  func contains(word: String) -> Bool {
    guard !word.isEmpty else { return false }
    var currentNode = root

    let characters = Array(word)
    var currentIndex = 0

    while currentIndex < characters.count, let child = currentNode.children[characters[currentIndex]] {

      currentIndex += 1
      currentNode = child
    }
    
    if currentIndex == characters.count && currentNode.isTerminating {
      return true
    } else {
      return false
    }
  }
  
  func getDescendants(prefix: String, maxResultLen: Int? = nil) -> [String]? {
    var currentNode = root
    let characters = Array(prefix)
    var i = 0
    
    while i < characters.count,
          let child = currentNode.children[characters[i]] {
      currentNode = child
      i += 1
    }
    
    guard i == characters.count else {
      return nil
    }
    
    var result = [String]()
    
    if currentNode.isTerminating {
      result.append(prefix)
    }
    
    recursiveDFS(from: currentNode,
                 result: &result,
                 prefix: characters,
                 maxLen: maxResultLen)
    
    return result
  }
}


//MARK: -DFS
extension PrefixTrie {
  private func recursiveDFS(from currentNode: Node,
                            result: inout [String],
                            prefix: [Character],
                            maxLen: Int? = nil) -> Bool {
    
    for child in currentNode.children.values {
      guard let nextChar = child.value else {
        return false
      }
      
      var newPrefix = prefix
      newPrefix.append(nextChar)
      
      if child.isTerminating {
        result.append(String(newPrefix))
        if result.count == maxLen {
          return true
        }
      }
      
      let reachedLimit = recursiveDFS(from: child,
                                  result: &result,
                                  prefix: newPrefix,
                                  maxLen: maxLen)
      if reachedLimit {
        return true
      }
    }
    return false
  }
}
