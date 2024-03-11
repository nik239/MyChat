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
  
}

// MARK: - Creating listeners
extension FirestoreService {
  func createChatsListener() {
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
  
  private func updateChat(withID id: String, fromDocument doc: QueryDocumentSnapshot) {
    do {
      let chatNew = try doc.data(as: Chat.self)
      
      if chatNew.name == "" {
        let otherMembers = chatNew.members.filter { $0 != appState.userData.user?.displayName }
        chatNew.name = otherMembers.joined(separator: ",")
      }
      guard let chatOld = appState.userData.chats[id] else {
        appState.userData.chats[id] = chatNew
        createMessagesListener(withChatID: id)
        return
      }
      chatOld.members = chatNew.members
      chatOld.pending = chatNew.pending
      chatOld.name = chatNew.name
    } catch {
      print(error)
    }
  }
  
  private func createMessagesListener(withChatID id: String) {
    db.collection("chats").document(id).collection("messages")
      .addSnapshotListener { querySnapshot, error in
        guard let messageDocs = querySnapshot?.documents else {
          assertionFailure("Failed to load messages for Chat id: \(id)")
          return
        }
        let messages = messageDocs.compactMap { doc -> Message? in
          do {
            let message = try doc.data(as: Message.self)
            return message
          } catch {
            print(error)
            return nil
          }
        }
        let sortedMessages = messages.sorted { $0.date < $1.date }
        self.appState.userData.chats[id]?.lastMessage = sortedMessages.last?.date
        self.appState.userData.chats[id]?.messages = sortedMessages
      }
  }
}

// MARK: - Writing
extension FirestoreService {
//  func createChat(chat: Chat) {
//    db.collection("chats").document().setData()
//  }
  func sendMessage(message: Message, toChat id: String) -> Bool {
    do {
      let data = try Firestore.Encoder().encode(message)
      db.collection("chats").document(id).collection("messages").document().setData(data)
      return true
    } catch {
      print(error)
      return false
    }
  }
}
