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
        .buttonStyle(PrimaryButtonStyle(image: "figure.2"))
        HStack {
          Button(action: {
            print("Join")
          }, label: {
            Text("Join")
          })
          .buttonStyle(PrimaryButtonStyle(image: "play.square.stack.fill"))
          Button(action: {
            print("Host")
          }, label: {
            Text("Host")
          })
          .buttonStyle(PrimaryButtonStyle(image: "house.fill"))
        }
        HStack {
          Button(action: {
            print("Rules")
          }, label: {
            Text("Rules")
              .foregroundStyle(.primary)
          })
          .buttonStyle(PrimaryButtonStyle(image: "questionmark.diamond.fill"))
          NavigationLink(destination: SettingsView()) {
            Text("Stats")
          }
          .buttonStyle(PrimaryButtonStyle(image: "chart.bar.xaxis"))
        }
      }
      .padding()
    }
  }
}

struct PrimaryButtonStyle: ButtonStyle {
  @State var image: String
  init(image: String = "") {
    self.image = image
  }
  func makeBody(configuration: Configuration) -> some View {
    ZStack {
      ZStack(alignment: .topTrailing) {
        Text("")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(configuration.isPressed ? Color("ForegroundColor").opacity(0.5) : Color("ForegroundColor"))
          .foregroundColor(.primary)
          .clipShape(Rectangle())
          .cornerRadius(10)
          .shadow(radius: 3)
          .padding(5)
        Text(">")
          .foregroundColor(.primary)
          .font(.system(size: 15, weight: .bold, design: .rounded))
          .padding()
      }
      LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .top, endPoint: .bottom).mask(Image(systemName: image)
        .resizable()
        .scaledToFit()
        .padding()
        .opacity(0.5))
      configuration.label
        .font(.system(size: 20, weight: .bold))
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
