//
//  Chat.swift
//  MyChat
//
//  Created by Nikita Ivanov on 08/03/2024.
//

import Foundation

struct Chat: Codable {
  var members: [String]
  var pending: [String]
  
  var messages: [Message]?
  
  var name: String
  
  init(members: [String], pending: [String], name: String = ""){
    self.members = members
    self.pending = pending
    self.name = name
  }
  
  enum CodingKeys: String, CodingKey {
    case members, name, pending
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.members = try container.decode([String].self, forKey: .members)
    self.pending = try container.decode([String].self, forKey: .pending)
    self.name = try container.decode(String.self, forKey: .name)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(members, forKey: .members)
    try container.encode(pending, forKey: .pending)
    try container.encode(name, forKey: .name)
  }
}
