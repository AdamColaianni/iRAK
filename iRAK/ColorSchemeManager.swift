//
//  ColorSchemeManager.swift
//  iRAK
//
//  Created by 90310013 on 4/1/24.
//  Credit to Shameem Reza
//  https://github.com/shameemreza/wordleclone
//

import SwiftUI

enum ColorScheme: Int {
  case unspecified, light, dark
}

class ColorSchemeManager: ObservableObject {
  @AppStorage("colorScheme") var colorScheme: ColorScheme = .unspecified {
    didSet {
      applyColorScheme()
    }
  }
  
  func applyColorScheme() {
    UIWindow.key?.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: colorScheme.rawValue)!
  }
}
