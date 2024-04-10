//
//  ContentView.swift
//  iRAK
//
//  Created by 64016641 on 3/7/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    ZStack {
      Color("BackgroundColor")
        .ignoresSafeArea()
      VStack {
        Button(action: {
          print("Label")
        }, label: {
          Text("")
        })
        .buttonStyle(PrimaryButtonStyle(image: "", color: .orange))
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

struct PrimaryButtonStyle: ButtonStyle {
  @State var image: String
  @State var color: Color
  
  func makeBody(configuration: Configuration) -> some View {
    VStack {
      HStack {
        configuration.label
          .font(.system(size: 20, weight: .bold))
        Spacer()
        Image(systemName: "chevron.right")
          .foregroundColor(.primary)
          .font(.system(size: 15, weight: .bold, design: .rounded))
          .opacity(0.5)
      }
      LinearGradient(gradient: Gradient(colors: [.gray, color]), startPoint: .top, endPoint: .bottom).mask(Image(systemName: image)
        .resizable()
        .scaledToFit()
        .padding(5))
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(configuration.isPressed ? Color("ForegroundColor").opacity(0.5) : Color("ForegroundColor"))
    .foregroundColor(.primary)
    .clipShape(Rectangle())
    .cornerRadius(10)
    .shadow(radius: 3)
    .padding(5)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
