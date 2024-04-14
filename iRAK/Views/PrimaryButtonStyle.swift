//
//  PrimaryButtonStyle.swift
//  iRAK
//
//  Created by 90310013 on 4/14/24.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
  @State var image: String
  @State var color: Color
  
  func makeBody(configuration: Configuration) -> some View {
    VStack {
      HStack {
        configuration.label
          .font(.system(size: 20, weight: .bold))
        Spacer()
        Image(systemName: "chevron.right")
          .foregroundColor(.primary)
          .font(.system(size: 15, weight: .bold, design: .rounded))
          .opacity(0.5)
      }
      LinearGradient(gradient: Gradient(colors: [.gray, color]), startPoint: .top, endPoint: .bottom).mask(Image(systemName: image)
        .resizable()
        .scaledToFit()
        .padding(5))
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(configuration.isPressed ? Color("ForegroundColor").opacity(0.5) : Color("ForegroundColor"))
    .foregroundColor(.primary)
    .clipShape(Rectangle())
    .cornerRadius(10)
    .shadow(radius: 3)
    .padding(5)
  }
}
