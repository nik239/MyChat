//
//  ListenerManager.swift
//  MyChat
//
//  Created by Nikita Ivanov on 09/03/2024.
//

import FirebaseFirestore
import Foundation

class ListenerManager {
    private var listeners = [String: ListenerRegistration]()

    func addListener(withID listenerID: String, forQuery query: Query, completion: @escaping ([DocumentSnapshot]?, Error?) -> Void) {
        if listeners[listenerID] == nil {
            let listenerRegistration = query.addSnapshotListener { (querySnapshot, error) in
                completion(querySnapshot?.documents, error)
            }
            listeners[listenerID] = listenerRegistration
        }
    }

    func removeListener(withID listenerID: String) {
        listeners[listenerID]?.remove()
        listeners.removeValue(forKey: listenerID)
    }
}
