//
//  Chat.swift
//  MyChat
//
//  Created by Nikita Ivanov on 08/03/2024.
//

import Foundation

// MARK: - Chat
struct Chat: Identifiable {
  let id: UUID
  
  var members: [String]
  var name: String
  
  var messages: [Message]?
  var userInput: String?
  
  init(members: [String], name: String = ""){
    self.members = members
    self.name = name
    self.id = .init()
  }
}

// MARK: - Chat Codable
extension Chat: Codable {
  enum CodingKeys: String, CodingKey {
    case members, name
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.members = try container.decode([String].self, forKey: .members)
    self.name = try container.decode(String.self, forKey: .name)
    self.id = .init()
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(members, forKey: .members)
    try container.encode(name, forKey: .name)
  }
}

// MARK: - Chat Equatable
extension Chat: Equatable {
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.id == rhs.id && lhs.members == rhs.members
    }
}

// MARK: - Generate Chat Name
extension Chat {
  static func generateName(chat: Chat, user: String) -> String {
    let otherMembers = chat.members.filter { $0 != user }
    return otherMembers.joined(separator: ",")
  }
}

