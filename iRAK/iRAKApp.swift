//
//  iRAKApp.swift
//  iRAK
//
//  Created by 64016641 on 3/7/24.
//

import SwiftUI

@main
struct iRAKApp: App {
  @StateObject var csManager = ColorSchemeManager()
  var body: some Scene {
    WindowGroup {
      HomeView()
        .environmentObject(csManager)
    }
  }
}
