//
//  ProfilePictureView.swift
//  iRAK
//
//  Created by 90310013 on 5/17/24.
//

import SwiftUI

struct ProfilePictureView: View {
  var player: PlayerData
  
  var body: some View {
    VStack {
      Image(uiImage: UIImage(data: player.profileImageData) ?? UIImage())
        .profileImageStyle(width: 70, height: 70)
      
      Text(player.name)
        .font(.caption)
        .multilineTextAlignment(.center)
    }
  }
}
