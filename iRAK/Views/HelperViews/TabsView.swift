//
//  TabsView.swift
//  iRAK
//
//  Created by 90310013 on 4/14/24.
//

import SwiftUI

struct TabsView: View {
  @Binding var selectedTab: String
  var bottomPadding: CGFloat = 0
  
  init(selectedTab: Binding<String>) {
    UITabBar.appearance().isHidden = true
    _selectedTab = selectedTab
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let safeAreaInsetsBottom = windowScene.windows.first?.safeAreaInsets.bottom {
      bottomPadding = safeAreaInsetsBottom
    }
  }
  
  @State var xAxis: CGFloat = 0
  @Namespace var animation
  
  var body: some View {
    VStack {
      TabView(selection: $selectedTab) {
        WordBombHomeView()
          .background(TransparentHelper())
          .tag("bomb")
        TriviaTrenchHomeView()
          .background(TransparentHelper())
          .tag("trench")
        HeadsUpHomeView()
          .background(TransparentHelper())
          .tag("headsup")
        WardleHomeView()
          .background(TransparentHelper())
          .tag("wardle")
        SniperTrainerHomeView()
          .background(TransparentHelper())
          .tag("training")
      }
      HStack(spacing: 0) {
        ForEach(tabs, id: \.self) { image in
          GeometryReader { reader in
            Button(action: {
              withAnimation(.spring()) {
                selectedTab = image
                xAxis = reader.frame(in: .global).minX
              }
            }, label: {
              getTabImage(tab: image)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundColor(selectedTab == image ? getTabColor(image: image) : Color.gray)
                .padding(selectedTab == image ? 15 : 0)
                .background(Color.midgroundColor.opacity(selectedTab == image ? 1 : 0).clipShape(Circle()).shadow(radius: 3)).offset(x: selectedTab == image ? -14 : 0)
                .matchedGeometryEffect(id: image, in: animation)
                .offset(x: reader.frame(in: .global).minX - reader.frame(in: .global).midX + 14, y: selectedTab == image ? -50 : 0)
            })
            .onAppear(perform: {
              if selectedTab == tabs.first {
                xAxis = reader.frame(in: .global).minX
              }
            })
          }
          .frame(width: 25, height: 30)
          if image != tabs.last{Spacer(minLength: 0)}
        }
      }
      .padding(.horizontal, 30)
      .padding(.vertical)
      .background(Color.midgroundColor.clipShape(CustomTabShape(xAxis: xAxis)).cornerRadius(12).shadow(radius: 3))
      .padding(.horizontal)
      .padding(.bottom, bottomPadding)
    }
    .ignoresSafeArea(.all, edges: .bottom)
  }
}

#Preview {
  TabsView(selectedTab: .constant("bomb"))
}
