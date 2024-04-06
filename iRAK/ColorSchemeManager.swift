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
}
