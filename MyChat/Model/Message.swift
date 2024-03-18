//
//  Message.swift
//  MyChat
//
//  Created by Nikita Ivanov on 08/03/2024.
//

import Foundation
import FirebaseFirestore

struct Message: Codable, Identifiable {
  let id: UUID
  
  let author: String
  let content: String
  let date: Date
  
  enum CodingKeys: String, CodingKey {
    case author, content, date
  }
  
  init(author: String, content: String, date: Date = Date()) {
    self.author = author
    self.content = content
    self.date = date
    self.id = .init()
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.author = try container.decode(String.self, forKey: .author)
    self.content = try container.decode(String.self, forKey: .content)
    let timestamp = try container.decode(Timestamp.self, forKey: .date)
    self.date = timestamp.dateValue()
    self.id = .init()
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(author, forKey: .author)
    try container.encode(content, forKey: .content)
    let timestamp = Timestamp(date: date)
    try container.encode(timestamp, forKey: .date)
  }
}
