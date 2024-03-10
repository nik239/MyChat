//
//  Message.swift
//  MyChat
//
//  Created by Nikita Ivanov on 08/03/2024.
//

import Foundation

struct Message: Codable {
  let author: String
  let content: String
  let date: Date
}
