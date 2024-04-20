//
//  HeadsUpHomeView.swift
//  iRAK
//
//  Created by 90310013 on 4/16/24.
//

import SwiftUI

struct HeadsUpHomeView: View {
  var body: some View {
    VStack {
      Image("HeadsUp")
        .headerButtonStyle()
      Button(action: {
        print("Play")
      }, label: {
        Text("Play")
      })
      .buttonStyle(PrimaryButtonStyle(image: "play.house.fill", color: .green))
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
  HeadsUpHomeView()
}
