//
//  ProfileView.swift
//  iRAK
//
//  Created by 90310013 on 3/29/24.
//

import SwiftUI

struct SettingsView: View {
  @Environment(\.dismiss) var dismiss
  var body: some View {
    NavigationView {
      ZStack {
        Color.backgroundColor
          .ignoresSafeArea()
        VStack {
          ZStack {
            HStack {
              Text("Settings")
                .font(.system(size: 25, weight: .bold))
              Spacer()
            }
            HStack {
              Spacer()
              Button {
                dismiss()
              } label: {
                Image("x-symbol")
                  .resizable()
                  .frame(width: 18, height: 18)
              }
            }
          }
          .padding(.leading, 5)
          .padding(.trailing, 5)
          .padding(.bottom, 25)
          Toggle("Background Gradient", isOn: Settings.$isGradientShown)
            .padding()
            .background(Color.midgroundColor.cornerRadius(10).shadow(radius: 3))
          VStack {
            HStack {
              Text("Enable Gradient")
              Spacer()
            }
            Picker("Gradient Mode", selection: Settings.$isGradientShown) {
              Text("Yes")
                .tag(true)
              Text("No")
                .tag(false)
            }
          }
          .padding()
          .background(Color.midgroundColor.cornerRadius(10).shadow(radius: 3))
          .pickerStyle(.segmented)
          Spacer()
        }
        .padding()
      }
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
