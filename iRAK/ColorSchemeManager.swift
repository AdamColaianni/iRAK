//
//  ColorSchemeManager.swift
//  iRAK
//
//  Created by 90310013 on 4/1/24.
//

import SwiftUI

enum SchemeType: Int, Identifiable, CaseIterable {
  var id: Self { self }
  case system, light, dark
}

extension SchemeType {
  var title: String {
    switch self {
    case .system:
      return "System"
    case .light:
      return "Light"
    case .dark:
      return "Dark"
    }
  }
}

class ColorSchemeManager: ObservableObject {
  @AppStorage("systemThemeVal") var systemTheme: Int = SchemeType.allCases.first!.rawValue
  var selectedTheme: ColorScheme? {
    guard let theme = SchemeType(rawValue: systemTheme) else { return nil }
    switch theme {
    case .light:
      return .light
    case .dark:
      return .dark
    default:
      return nil
    }
  }
  
  // Very small bug where if your currently on the settings view and the color scheme is set to system
  // theme and you change the theme in settings, and go back to the app, settings view doesn't auto update
  var settingsViewTheme: ColorScheme? {
      if systemTheme == SchemeType.system.rawValue {
        if isDarkMode() {
          return .dark
        } else {
          return .light
        }
      } else {
        return selectedTheme
      }
  }
  
  private func isDarkMode() -> Bool {
    return UITraitCollection.current.userInterfaceStyle == .dark
  }
}
