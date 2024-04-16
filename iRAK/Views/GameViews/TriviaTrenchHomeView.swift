//
//  TriviaTrenchHomeView.swift
//  iRAK
//
//  Created by 90310013 on 4/16/24.
//

import SwiftUI

struct TriviaTrenchHomeView: View {
  @AppStorage("gradient") var isGradientShown: Bool = true
  @Binding var selectedTab: String
  var body: some View {
    ZStack {
      Color("BackgroundColor")
        .ignoresSafeArea()
      if isGradientShown {
        GradientView(selectedTab: $selectedTab)
      }
      VStack {
        Image("TriviaTrench")
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
}

#Preview {
  TriviaTrenchHomeView(selectedTab: .constant("archivebox"))
}
