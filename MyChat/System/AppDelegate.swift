//
//  AppDelegate.swift
//  MyChat
//
//  Created by Nikita Ivanov on 10/03/2024.
//

import UIKit
import FirebaseCore
import FirebaseAuth

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    #if DEBUG
    Auth.auth().useEmulator(withHost:"localhost", port:9099)
    #endif
    return true
  }
}
