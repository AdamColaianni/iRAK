//
//  ProfilePictureView.swift
//  iRAK
//
//  Created by 90310013 on 5/17/24.
//

import SwiftUI

struct ProfilePictureView: View {
  let name: String
  let imageData: Data
  
  var body: some View {
    VStack {
      Image(uiImage: UIImage(data: imageData) ?? UIImage())
        .profileImageStyle(width: 70, height: 70)
      
      Text(name)
        .font(.caption)
        .multilineTextAlignment(.center)
    }
  }
}

#Preview {
  ProfilePictureView(name: "Name", imageData: Data())
}
