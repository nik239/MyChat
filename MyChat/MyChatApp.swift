//
//  MyChatApp.swift
//  MyChat
//
//  Created by Nikita Ivanov on 05/02/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    #if DEBUG
    Auth.auth().useEmulator(withHost:"localhost", port:9099)
    #endif
    return true
  }
}

@main
struct MyChatApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  var body: some Scene {
    WindowGroup {
      NavigationView {
        AuthView(){
          ChatsView()
        }
      }
    }
  }
}
