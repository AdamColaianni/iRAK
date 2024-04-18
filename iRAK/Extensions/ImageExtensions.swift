//
//  ImageExtensions.swift
//  iRAK
//
//  Created by 90310013 on 4/14/24.
//

import SwiftUI

extension Image {
  func profileImageStyle(width: CGFloat, height: CGFloat) -> some View {
    self
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: width, height: height)
      .clipShape(Circle())
      .overlay(
        Circle().stroke(Color.primary, lineWidth: 2)
      )
      .shadow(radius: 3)
  }
  
  func headerButtonStyle() -> some View {
    self
      .resizable()
      .scaledToFit()
      .cornerRadius(10)
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(Color.primary, lineWidth: 3)
      )
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .shadow(radius: 3)
  }
}
