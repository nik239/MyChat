// The Swift Programming Language
// https://docs.swift.org/swift-book

public final class PrefixLoader {
  private let trie = PrefixTrie()
  
  public init(for strings: [String]) {
    strings.forEach {
      trie.insert(word: $0)
    }
  }
  
  public func loadFor(prefix: String,
                      maxResultLen: Int? = nil) throws -> [String] {
    if let maxLen = maxResultLen {
      guard maxLen > 0 else {
        throw LoadError.invalidMaxResultLen("maxResultLen must be > 0")
      }
    }
    
    return trie.getDescendants(prefix: prefix,
                               maxResultLen: maxResultLen) ?? []
  }
}

extension PrefixLoader {
  private enum LoadError: Error {
    case invalidMaxResultLen(String)
  }
}
