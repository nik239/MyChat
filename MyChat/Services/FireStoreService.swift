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
        self?.createChatsListener(forUser: self?.appState.userData.user?.displayName)
      }
      .store(in: &cancellables)
  }
}

// MARK: - Creating listeners
extension FirestoreService {
  /// Creates a listener on the chats collection.
  func createChatsListener(forUser userHandle: String?) {
    guard let userHandle = userHandle else {
      assertionFailure("User object is nil.")
      return
    }
    let listener = db.collection("chats").whereField("members",  arrayContains: userHandle)
      .addSnapshotListener { querySnapshot, error in
        if let error = error {
          print(error)
        }
        let chats = querySnapshot?.documents
        chats?.forEach { self.updateChat(withID: $0.documentID, fromDocument: $0)
        }
      }
    self.listeners.append(listener)
  }
  
  /// Updates a chat's fields other than messages. If the chat's id is not in the chat table, adds it to the table and creates a listener on the chats messages.
  private func updateChat(withID id: String, fromDocument doc: QueryDocumentSnapshot) {
    guard var chatNew = try? doc.data(as: Chat.self) else {
      return
    }
    
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
    chat.name = chatNew.name
    
    appState.update(chatAtID: id, to: chat)
  }
  
  /// Creates a listener on a chat's messages subcollection. The listener updates the corresponding chat in AppState when a new message is posted. Throws if listener creation fails.
  func createMessagesListener(withChatID id: String) {
    let listener = db.collection("chats").document(id).collection("messages")
      .addSnapshotListener { querySnapshot, error in
        if let error = error {
         print(error)
        }
        let sortedMessages = querySnapshot?.documents.compactMap { doc -> Message? in
          let message = try? doc.data(as: Message.self)
          return message
        }.sorted { $0.date < $1.date }
        guard var chat = self.appState.userData.chats[id] else {
          return
        }
        chat.messages = sortedMessages
        self.appState.update(chatAtID: id, to: chat)
      }
    self.listeners.append(listener)
  }
}

// MARK: - Writing
extension FirestoreService {
  /// Creates a chat, optionally specifying its Firestore document id. The id parameter is meant for testing purposes.
  func updateChat(chat: Chat, withID id: String? = nil) async throws {
    let data = try Firestore.Encoder().encode(chat)
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
      var reference = db.collection("chats")
      .document()
      if let id = id {
        reference = db.collection("chats").document(id)
      }
      reference.setData(data) { error in
        if let error = error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume(returning: ())
        }
      }
    }
  }
  
  func sendMessage(message: Message, toChat id: String) async throws {
    let data = try Firestore.Encoder().encode(message)
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
      db.collection("chats").document(id).collection("messages").document().setData(data){ error in
        if let error = error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume(returning: ())
        }
      }
    }
  }
}
