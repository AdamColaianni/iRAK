//
//  HomeView.swift
//  iRAK Bubble Bar Home View
//
//  Created by 90310013 on 3/14/24.
//
// Credit to https://www.youtube.com/watch?v=Lw-vimpu6Cs for the tab view
//

import SwiftUI

struct HomeView: View {
  @EnvironmentObject var csManager: ColorSchemeManager
  @State private var isSettingsPresented = false
  @State private var isProfilePresented = false
  @State var selectedTab = "house"
  @AppStorage("gradient") var isGradientShown: Bool = true
  @AppStorage("selectedProfilePhotoData") private var selectedProfilePhotoData: Data?
  
  var body: some View {
    NavigationView {
      ZStack {
        Color("BackgroundColor")
          .ignoresSafeArea()
        if isGradientShown {
          TopGradientView(selectedTab: $selectedTab)
        }
        VStack {
          // Buttons on top
          HStack {
            Button(action: {
              self.isSettingsPresented.toggle()
            }) {
              ZStack {
                Circle()
                  .fill(Color("ForegroundColor"))
                  .shadow(radius: 3)
                  .frame(width: 40, height: 40)
                Image(systemName: "gearshape.fill")
                  .foregroundColor(.primary)
              }
            }
            
            Spacer()
            
            Text(getTitle(sheetNum: selectedTab))
              .dynamicTypeSize(.xxxLarge)
              .bold()
            
            Spacer()
            
            Button(action: {
              self.isProfilePresented.toggle()
            }) {
              if let selectedProfilePhotoData, let uiImage = UIImage(data: selectedProfilePhotoData) {
                Image(uiImage: uiImage)
                  .profileImageStyle(width: 40, height: 40)
              } else {
                ZStack {
                  Circle()
                    .fill(Color("ForegroundColor"))
                    .shadow(radius: 3)
                    .frame(width: 40, height: 40)
                  Image(systemName: "person.circle.fill")
                    .foregroundColor(.primary)
                }
              }
            }
          }
          .padding(.horizontal)
          .dynamicTypeSize(.xxxLarge)
          
          // Tab view at the bottom
          TabsView(selectedTab: $selectedTab)
            .animation(.spring(), value: selectedTab)
        }
        .fullScreenCover(isPresented: $isSettingsPresented) {
          SettingsView()
        }
        .fullScreenCover(isPresented: $isProfilePresented) {
          ProfileView()
        }
      }
    }
    .preferredColorScheme(csManager.selectedTheme)
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
      .environmentObject(ColorSchemeManager())
  }
}
