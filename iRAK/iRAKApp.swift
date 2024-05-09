//
//  iRAKApp.swift
//  iRAK
//
//  Created by 64016641 on 3/7/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct iRAKApp: App {
  @StateObject var settings: Settings = Settings()
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
  init() {
    Task {
      do {
        try await AuthenticationManager.shared.signInAnonymous()
      } catch {
        print(error)
      }
    }
  }
  
  var body: some Scene {
    WindowGroup {
      HomeView()
        .environmentObject(settings)
    }
  }
}
