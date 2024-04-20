//
//  SniperTrainerHomeView.swift
//  iRAK
//
//  Created by 90310013 on 4/16/24.
//

import SwiftUI

struct SniperTrainerHomeView: View {
  var body: some View {
    VStack {
      Image("SniperTraining")
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
  SniperTrainerHomeView()
}
