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
  let db: Firestore
  
  private var cancellables = Set<AnyCancellable>()
  private var listeners = [ListenerRegistration]()
  //let listenerManager = ListenerManager()
  
  init(appState: AppState) {
    db = Firestore.firestore()
    self.appState = appState
    createUserObserver()
  }

  /// Creates a subscriber that manages listeners upon successful user authentication.
  private func createUserObserver() {
    appState.$userData
      .map { $0.user }
      .removeDuplicates()
      .compactMap { $0 }
      .sink { [weak self] _ in
        self?.listeners.forEach { $0.remove() }
        self?.listeners = []
        self?.createChatsListener()
      }
      .store(in: &cancellables)
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
  func createChat(chat: Chat) async throws {
    let data = try Firestore.Encoder().encode(chat)
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
      db.collection("chats").document().setData(data) { err in
        if let err = err {
          continuation.resume(throwing: err)
        } else {
          continuation.resume(returning: ())
        }
      }
    }
  }
  
  func sendMessage(message: Message, toChat id: String) async throws {
    let data = try Firestore.Encoder().encode(message)
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
      db.collection("chats").document(id).collection("messages").document().setData(data){ err in
        if let err = err {
          continuation.resume(throwing: err)
        } else {
          continuation.resume(returning: ())
        }
      }
    }
  }
}
