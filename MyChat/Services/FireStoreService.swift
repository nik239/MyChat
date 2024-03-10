//
//  FireStoreService.swift
//  MyChat
//
//  Created by Nikita Ivanov on 22/02/2024.
//

import FirebaseFirestore

class FirestoreService {
  let appState: AppState
  
  let db = Firestore.firestore()
  //let listenerManager = ListenerManager()
  
  init(appState: AppState) {
    self.appState = appState
  }
  
  private func createChatsListener() {
    guard let userHandle = appState.userData.user?.displayName else {
      assertionFailure("User object is nil")
      return
    }
    
    db.collection("chats").whereField("members",  arrayContains: userHandle)
      .addSnapshotListener { querySnapshot, error in
        guard let chats = querySnapshot?.documents else {
          assertionFailure("Failed to load chats!")
          return
        }
        chats.forEach { self.updateChat(withID: $0.documentID, fromDocument: $0) }
      }
  }
  
  private func updateChat(withID id: String, fromDocument document: QueryDocumentSnapshot) {
    
    guard let members = document["members"] as? [String], let pending = document["pending"] as? [String] else {
      assertionFailure("Failed to access fields of a chat doc")
      return
    }
    
    guard let chat = appState.userData.chats[id] else {
      appState.userData.chats[id] = Chat(members: members, pending: pending)
      createMessagesListener(withChatID: id)
      return
    }
    
    chat.members = members
    chat.pending = pending
  }
  
  private func createMessagesListener(withChatID id: String) {
    db.collection("chats").document(id).collection("messages")
      .addSnapshotListener { querySnapshot, error in
        guard let messageDocs = querySnapshot?.documents else {
          assertionFailure("Failed to load messages for Chat id: \(id)")
          return
        }
        let messages = messageDocs.compactMap { doc -> Message? in
          guard let author = doc["author"] as? String,
                let content = doc["content"] as? String,
                let timestamp = doc["date"] as? Timestamp else {
            assertionFailure("Failed to access fields of a message doc")
            return nil
          }
          return Message(author: author, content: content, date: timestamp.dateValue())
        }
        self.appState.userData.chats[id]?.messages = messages
    }
  }
}
