//
//  ProfileView.swift
//  iRAK
//
//  Created by 90310013 on 3/29/24.
//

import SwiftUI

struct ProfileView: View {
  @Environment(\.dismiss) var dismiss
  var body: some View {
    NavigationView {
      ZStack {
        Color("BackgroundColor")
          .ignoresSafeArea()
        VStack {
          Text("Hello, World!")
        }
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              dismiss()
            } label: {
              Text("**X**")
            }
          }
        }
      }
    }
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView()
  }
}
