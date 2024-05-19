//
//  ProfilePicturesScrollView.swift
//  iRAK
//
//  Created by 90310013 on 5/17/24.
//

import SwiftUI

struct ProfilePicturesScrollView: View {
  @Binding var profilePictures: [String: Data]
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 10) {
        ForEach(profilePictures.sorted(by: { $0.key < $1.key }), id: \.key) { name, imageData in
          ProfilePictureView(name: name, imageData: imageData)
        }
      }
      .padding()
    }
  }
}

#Preview {
  ProfilePicturesScrollView(profilePictures: .constant(["name": Data()]))
}
