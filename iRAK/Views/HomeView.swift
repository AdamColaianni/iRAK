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
  @EnvironmentObject var settings: Settings
  @State private var isSettingsPresented = false
  @State private var isProfilePresented = false
  @State var selectedTab = "bomb"
  
  var body: some View {
    NavigationView {
      ZStack {
        Color.backgroundColor
          .ignoresSafeArea()
        if settings.isGradientShown {
          GradientView(selectedTab: $selectedTab)
        }
        VStack {
          // Buttons on top
          HStack {
            Button(action: {
              self.isSettingsPresented.toggle()
            }) {
              ZStack {
                Circle()
                  .fill(Color.midgroundColor)
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
              if let imageData = settings.selectedProfilePhotoData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                  .profileImageStyle(width: 40, height: 40)
              } else {
                ZStack {
                  Circle()
                    .fill(Color.midgroundColor)
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
            .background(Color.clear)
        }
        .fullScreenCover(isPresented: $isSettingsPresented) {
          SettingsView()
        }
        .fullScreenCover(isPresented: $isProfilePresented) {
          ProfileView()
        }
      }
    }
//    .onAppear {
//      if (try? AuthenticationManager.shared.getAuthenticatedUser()) != nil {
//        print("THERE IS A USER!")
//      }
//    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
      .environmentObject(Settings())
  }
}
