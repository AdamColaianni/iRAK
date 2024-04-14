//
//  SchemeType.swift
//  iRAK
//
//  Created by 90310013 on 4/14/24.
//

import Foundation

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
