//
//  Chat.swift
//  MyChat
//
//  Created by Nikita Ivanov on 08/03/2024.
//

import Foundation

class Chat {
  var members: [String]
  var pending: [String]
  
  var messages: [Message]?
  
  init(members: [String], pending: [String]){
    self.members = members
    self.pending = pending
  }
}
