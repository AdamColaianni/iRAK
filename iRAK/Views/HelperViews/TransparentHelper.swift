//
//  TransparentHelper.swift
//  iRAK
//
//  Created by 90310013 on 4/19/24.
//

import SwiftUI

// https://stackoverflow.com/questions/63178381/make-tabview-background-transparent
struct TransparentHelper: UIViewRepresentable {
  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    DispatchQueue.main.async {
      // find first superview with color and make it transparent
      var parent = view.superview
      repeat {
        if parent?.backgroundColor != nil {
          parent?.backgroundColor = UIColor.clear
          break
        }
        parent = parent?.superview
      } while (parent != nil)
    }
    return view
  }
  func updateUIView(_ uiView: UIView, context: Context) {}
}
