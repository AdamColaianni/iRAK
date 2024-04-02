//
//  ProfileView.swift
//  iRAK
//
//  Created by 90310013 on 3/29/24.
//  Credit to Shameem Reza for some parts of the src code
//  https://github.com/shameemreza/wordleclone
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
          Toggle("Hard Mode", isOn: $hardMode)
            .padding()
            .background(Color("ForegroundColor").cornerRadius(10).shadow(radius: 3))
          VStack {
            HStack {
              Text("Change Theme")
              Spacer()
            }
            Picker("Display Mode", selection: $csManager.colorScheme) {
              Text("Dark").tag(ColorScheme.dark)
              Text("Light").tag(ColorScheme.light)
              Text("System").tag(ColorScheme.unspecified)
            }
          }
          .padding()
          .background(Color("ForegroundColor").cornerRadius(10).shadow(radius: 3))
          
            .pickerStyle(.segmented)
          Spacer()
        }.padding()
          .navigationTitle("Options")
          .navigationBarTitleDisplayMode(.inline)
          .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
              Button {
                dismiss()
              } label: {
                Text("X")
                  .font(.system(size: 20, weight: .bold, design: .rounded))
                  .foregroundColor(.primary)
              }
            }
          }
      }
    }
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
      .environmentObject(ColorSchemeManager())
  }
}
