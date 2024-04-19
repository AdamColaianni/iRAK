//
//  ProfileButton.swift
//  iRAK
//
//  Created by 90310013 on 4/14/24.
//

import SwiftUI

struct ProfileButton: View {
  @State var imageName: String
  @State var text: String
  
  var body: some View {
    HStack {
      Image(systemName: imageName)
      Text(text)
      Spacer()
      Image(systemName: "chevron.right")
    }
    .padding()
    .background(Color.midgroundColor)
    .foregroundColor(.primary)
    .cornerRadius(15)
    .shadow(radius: 3)
    .padding(.horizontal)
    .font(.system(size: 20))
  }
}

#Preview {
  ProfileButton(imageName: "bell", text: "Updates")
}
