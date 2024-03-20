//
//  AppDelegate.swift
//  MyChat
//
//  Created by Nikita Ivanov on 10/03/2024.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    print("Calling didFinishLaunching")
    FirebaseApp.configure()
    #if DEBUG
    Auth.auth().useEmulator(withHost:"localhost", port:9099)
    let settings = Firestore.firestore().settings
    settings.host = "127.0.0.1:8080"
    settings.cacheSettings = MemoryCacheSettings()
    settings.isSSLEnabled = false
    Firestore.firestore().settings = settings
    #endif
    return true
  }
}
