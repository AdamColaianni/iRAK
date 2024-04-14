//
//  ProfileView.swift
//  iRAK
//
//  Created by 90310013 on 3/29/24.
//

import SwiftUI

struct SettingsView: View {
  @EnvironmentObject var csManager: ColorSchemeManager
  @State var hardMode: Bool = false
  @Environment(\.dismiss) var dismiss
  var body: some View {
    NavigationView {
      ZStack {
        Color("BackgroundColor")
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
          Toggle("Hard Mode", isOn: $hardMode)
            .padding()
            .background(Color("ForegroundColor").cornerRadius(10).shadow(radius: 3))
          VStack {
            HStack {
              Text("Change Theme")
              Spacer()
            }
            Picker("Display Mode", selection: $csManager.systemTheme) {
              ForEach(SchemeType.allCases) { item in
                Text(item.title)
                  .tag(item.rawValue)
              }
            }
          }
          .padding()
          .background(Color("ForegroundColor").cornerRadius(10).shadow(radius: 3))
          .pickerStyle(.segmented)
          Spacer()
        }
        .padding()
      }
    }
    .preferredColorScheme(csManager.settingsViewTheme)
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
      .environmentObject(ColorSchemeManager())
  }
}
