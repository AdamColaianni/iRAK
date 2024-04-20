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
        Button(action: {
          print("Join")
        }, label: {
          Text("Join")
        })
        .buttonStyle(PrimaryButtonStyle(image: "play.house.fill", color: .green))
        Button(action: {
          print("Host")
        }, label: {
          Text("Host")
        })
        .buttonStyle(PrimaryButtonStyle(image: "house.fill", color: .pink))
      }
      HStack {
        Button(action: {
          print("Rules")
        }, label: {
          Text("Rules")
            .foregroundStyle(.primary)
        })
        .buttonStyle(PrimaryButtonStyle(image: "questionmark.diamond.fill", color: .blue))
        NavigationLink(destination: SettingsView()) {
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
