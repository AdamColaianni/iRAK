//
//  UIWindow+Extension.swift
//  iRAK
//
//  Created by 90310013 on 4/1/24.
//  Credit to Shameem Reza
//  https://github.com/shameemreza/wordleclone
//

import UIKit

extension UIWindow {
  static var key: UIWindow? {
    guard let scene = UIApplication.shared.connectedScenes.first,
          let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
          let window = windowSceneDelegate.window else {
      return nil
    }
    return window
  }
}
