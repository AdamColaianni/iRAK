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
        }.padding()
          .navigationTitle("Options")
          .navigationBarTitleDisplayMode(.inline)
          .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
              Button {
                dismiss()
              } label: {
                Image("x-symbol")
                  .resizable()
                  .frame(width: 15, height: 15)
                  .font(.system(size: 20, weight: .bold, design: .rounded))
              }
            }
          }
      }
    }
    .preferredColorScheme(csManager.selectedTheme)
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
      .environmentObject(ColorSchemeManager())
  }
}
