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
  
  var body: some View {
    NavigationView {
      ZStack {
        Color("BackgroundColor")
          .ignoresSafeArea()
        GeometryReader { geometry in
          LinearGradient(gradient: Gradient(stops: [
            Gradient.Stop(color: .blue, location: 0.1),
            Gradient.Stop(color: .purple, location: 0.5),
            Gradient.Stop(color: .green, location: 1),
          ]), startPoint: .topTrailing, endPoint: .bottomLeading)
          .frame(height: geometry.size.height / 7)
          .mask(LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), .clear]), startPoint: .top, endPoint: .bottom))
          .mask(
            Color("BackgroundColor")
              .opacity((csManager.selectedTheme == .dark || (csManager.selectedTheme == nil && UITraitCollection.current.userInterfaceStyle == .dark)) ? 0.5 : 1)
          )
          .ignoresSafeArea()
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
          .padding(.horizontal)
          .dynamicTypeSize(.xxxLarge)
          
          // Tab view at the bottom
          TabsView(selectedTab: $selectedTab)
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
