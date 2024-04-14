//
//  ImageExtensions.swift
//  iRAK
//
//  Created by 90310013 on 4/14/24.
//

import SwiftUI

extension Image {
  func profileImage() -> some View {
    self
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: 100, height: 100)
      .clipShape(Circle())
      .overlay(
        Circle().stroke(Color.primary, lineWidth: 2)
      )
      .shadow(radius: 3)
  }
  
  func headerButtonStyle(text: String) -> some View {
    ZStack {
      self
        .resizable()
        .scaledToFit()
        .opacity(0.8)
        .blur(radius: 1)
        .overlay(Color(.blue).opacity(0.4))
        .cornerRadius(10)
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(Color.primary, lineWidth: 3)
        )
        .shadow(radius: 3)
//      Text(text)
//        .font(.system(size: 25, weight: .bold))
//        .shadow(radius: 10)
    }
    .padding(5)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color("ForegroundColor"))
//    .foregroundColor(.green)
//    .clipShape(Rectangle())
    .cornerRadius(10)
    .shadow(radius: 3)
    .padding(5)
  }
}
