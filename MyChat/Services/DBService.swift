//
//  FireStoreService.swift
//  MyChat
//
//  Created by Nikita Ivanov on 22/02/2024.
//

import FirebaseFirestore
import Combine

protocol DBService {
  func sendMessage(message: Message, toChatWithID id: String) async throws
  func updateChat(chat: Chat, withID id: String?) async throws
}

final class FireStoreService: DBService {
  let appState: AppState
  let db: Firestore
  
  private var cancellables = Set<AnyCancellable>()
  private var listeners = [ListenerRegistration]()
  
  init(appState: AppState) {
    db = Firestore.firestore()
    self.appState = appState
    createUserObserver()
  }

  /// Creates a subscriber that manages listeners upon successful user authentication.
  private func createUserObserver() {
    Task {
      let userValues = await appState.$userData.compactMap{$0.user}.removeDuplicates().values
      for await user in userValues {
        self.listeners.forEach { $0.remove() }
        self.listeners = []
        self.configureListeners(forUser: user.displayName)
      }
    }
  }
}

// MARK: - FireStoreService Configuring Listeners
extension FireStoreService {
  /// Configures listeners on FireStore collections. Listeners are responsible for updating AppState when new data becomes available.
  func configureListeners(forUser userID: String?) {
    guard let userID = userID else {
      assertionFailure("User object is nil.")
      return
    }
    
    let listener = db.collection("chats").whereField("members",  arrayContains: userID)
      .addSnapshotListener { querySnapshot, error in
        
      guard let chatDocs = querySnapshot?.documents else {
        if let error = error {
          assertionFailure("\(error)")
        }
        return
      }
      
      Task {
        let newChatTable = await self.getUpdatedChatTable(from: chatDocs, forUser: userID)
        await self.appState.update(chats: newChatTable)
      }
    }
    
    self.listeners.append(listener)
  }
  
  /// Generates updated ChatsTable.
  func getUpdatedChatTable(from chatDocs: [QueryDocumentSnapshot], forUser userID: String) async -> ChatTable {
    var chatTable = await appState.userData.chats
    
    await withTaskGroup(of: (String, Chat?).self) { group in
      for chatDoc in chatDocs {
        let id = chatDoc.documentID
        let oldChat = chatTable[id]
        
        group.addTask {
          let updatedChat = self.getUpdatedChat(from: oldChat, with: chatDoc)
          return (id, updatedChat)
        }
      }
      
      for await (id, updatedChat) in group {
        chatTable[id] = updatedChat
      }
    }
    
    return chatTable
  }
  
  /// Updates a chat using a document snapshot, if chat isn't registered, creates a listener on its Messages subcollection
  func getUpdatedChat(from chatOld: Chat?, with chatDoc: QueryDocumentSnapshot) -> Chat? {
    guard let chatNew = try? chatDoc.data(as: Chat.self) else {
      return chatOld
    }
    guard var chatOld = chatOld else {
      configureMessagesListener(forChatID: chatDoc.documentID)
      return chatNew
    }
    chatOld.members = chatNew.members
    chatOld.name = chatNew.name
    
    return chatOld
  }
  
  /// Creates a listener on a chat's messages subcollection. The listener updates the corresponding chat in AppState when a new message is posted.
  func configureMessagesListener(forChatID id: String) {
    let listener = db.collection("chats").document(id).collection("messages")
      .addSnapshotListener { querySnapshot, error in
        if let error = error {
         assertionFailure("\(error)")
        }
        
        let sortedMessages = querySnapshot?.documents.compactMap { doc -> Message? in
          let message = try? doc.data(as: Message.self)
          return message
        }
        .sorted { $0.date < $1.date }
        
        Task {
          await self.appState.update(messagesAtID: id, to: sortedMessages)
        }
        
      }
    
    self.listeners.append(listener)
  }
}

// MARK: - FireStoreService Writing to Firestore
extension FireStoreService {
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
  
  func sendMessage(message: Message, toChatWithID id: String) async throws {
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

// MARK: - StubFireStoreService
final class StubFireStoreService: DBService {
  func sendMessage(message: Message, toChatWithID id: String) async throws { }
  func updateChat(chat: Chat, withID id: String?) async throws { }
}
