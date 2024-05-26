//
//  ProfilePicturesScrollView.swift
//  iRAK
//
//  Created by 90310013 on 5/17/24.
//

import SwiftUI

struct ProfilePicturesScrollView: View {
  @Binding var profilePictures: [PlayerData]
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 10) {
        ForEach(profilePictures.sorted(by: { $0.name < $1.name })) { player in
          ProfilePictureView(player: player)
        }
      }
      .padding()
    }
  }
}
