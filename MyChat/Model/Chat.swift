//
//  Chat.swift
//  MyChat
//
//  Created by Nikita Ivanov on 08/03/2024.
//

import Foundation

struct Chat: Codable, Identifiable {
  let id: UUID
  
  var members: [String]
  var name: String
  
  var messages: [Message]?
  
  init(members: [String], name: String = ""){
    self.members = members
    self.name = name
    self.id = .init()
  }
  
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
