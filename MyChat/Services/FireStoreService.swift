//
//  FireStoreService.swift
//  MyChat
//
//  Created by Nikita Ivanov on 22/02/2024.
//

import FirebaseFirestore
import Combine

class FirestoreService {
  let appState: AppState
  let db = Firestore.firestore()
  
  private var cancellables = Set<AnyCancellable>()
  //let listenerManager = ListenerManager()
  
  init(appState: AppState) {
    self.appState = appState
    observeDidAuthenticate()
  }

  private func observeDidAuthenticate() {
    appState.$userData
      .map { $0.user }
      .removeDuplicates()
      .compactMap { $0 } 
      .sink { [weak self] _ in
        self?.createChatsListener()
      }
      .store(in: &cancellables)
  }
}

// MARK: - Creating listeners
extension FirestoreService {
  // should be called once the user is no longer nil
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
      var chatNew = try doc.data(as: Chat.self)
      
      if chatNew.name == "" {
        let otherMembers = chatNew.members.filter { $0 != appState.userData.user?.displayName }
        chatNew.name = otherMembers.joined(separator: ",")
      }
      
      guard var chat = appState.userData.chats[id] else {
        appState.update(chatAtID: id, to: chatNew)
        createMessagesListener(withChatID: id)
        return
      }
      
      chat.members = chatNew.members
      chat.pending = chatNew.pending
      chat.name = chatNew.name
      
      appState.update(chatAtID: id, to: chat)
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
        
        guard var chat = self.appState.userData.chats[id] else {
          return
        }
        chat.messages = sortedMessages
        chat.lastMessage = sortedMessages.last?.date
        self.appState.update(chatAtID: id, to: chat)
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
