//
//  WardleHomeView.swift
//  iRAK
//
//  Created by 90310013 on 4/16/24.
//

import SwiftUI

struct WardleHomeView: View {
  var body: some View {
    VStack {
      Image("Wardle")
        .headerButtonStyle()
      NavigationLink(destination: Text("Play")) {
        Text("Play")
      }
      .buttonStyle(PrimaryButtonStyle(image: "play.house.fill", color: .green))
      HStack {
        NavigationLink(destination: Text("Rules")) {
          Text("Rules")
        }
        .buttonStyle(PrimaryButtonStyle(image: "questionmark.diamond.fill", color: .blue))
        NavigationLink(destination: Text("Stats")) {
          Text("Stats")
        }
        .buttonStyle(PrimaryButtonStyle(image: "chart.bar.xaxis", color: .purple))
      }
    }
    .padding()
  }
}

#Preview {
  WardleHomeView()
}
