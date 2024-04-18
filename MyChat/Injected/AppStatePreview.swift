//
//  AppStatePreview.swift
//  MyChat
//
//  Created by Nikita Ivanov on 13/04/2024.
//

#if DEBUG
// MARK: - Preview
extension AppState {
  nonisolated static var preview: AppState {
      let userData = AppState.UserData(authState: .unauthenticated,
                                       username: "test user",
                                       error: "",
                                       selectedChatID: "1",
                                       chats: self.previewChatsTable)
    
      let routing = AppState.ViewRouting(showBottomNavigation: true,
                                         showCreateChatView: false)

      return AppState(userData: userData, routing: routing)
  }
  
  nonisolated static var previewChatsTable: ChatTable {
    var chat1 = Chat(members: [], name: "Sam")
    var chat2 = Chat(members: [], name: "Merry")
    var chat3 = Chat(members: [], name: "Pipppin")
    
    let messageContent1 = "Hey, what's up. Hope everything is well. Do you have the ring?"
                          + " I was wondering if I could I borrow it for a little while."
    let messageContent2 = "Hey, this is Merry. Hope everything is well. Do you have the ring?"
                          + " I was wondering if I could I borrow it for a little while."
    
    chat1.messages = [Message(author: "Sam", content: messageContent1)]
    chat2.messages = [Message(author: "Merry", content: messageContent2)]
    chat3.messages = [Message(author: "Pippin", content: messageContent1)]
    
    return ["1": chat1, "2": chat2, "3": chat3]
  }
}

extension AppState {
  func update(selectedChatID: String) {
    userData.value.selectedChatID = selectedChatID
  }
}
#endif
