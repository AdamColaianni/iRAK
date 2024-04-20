//
//  ContentView.swift
//  iRAK
//
//  Created by 64016641 on 3/7/24.
//

import SwiftUI

struct WordBombHomeView: View {
  var body: some View {
    VStack {
      Image("WordBomb")
        .headerButtonStyle()
      HStack {
        NavigationLink(destination: Text("Join")) {
          Text("Join")
        }
        .buttonStyle(PrimaryButtonStyle(image: "play.house.fill", color: .green))
        NavigationLink(destination: Text("Host")){
          Text("Host")
        }
        .buttonStyle(PrimaryButtonStyle(image: "house.fill", color: .pink))
      }
      HStack {
        NavigationLink(destination: Text("Rules")){
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
  WordBombHomeView()
}
