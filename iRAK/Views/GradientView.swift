//
//  GradientView.swift
//  iRAK
//
//  Created by 90310013 on 4/16/24.
//

import SwiftUI

struct GradientView: View {
  @Binding var selectedTab: String
  @EnvironmentObject var csManager: ColorSchemeManager
  var body: some View {
    GeometryReader { geometry in
      LinearGradient(gradient: Gradient(stops: [
        Gradient.Stop(color: getRightTabColor(tab: selectedTab), location: -0.03),
        Gradient.Stop(color: getTabColor(image: selectedTab), location: 0.4),
        Gradient.Stop(color: getLeftTabColor(tab: selectedTab), location: 1),
      ]), startPoint: .topTrailing, endPoint: .bottomLeading)
      .frame(height: geometry.size.height / 3)
      .mask(LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), .clear]), startPoint: .top, endPoint: .bottom))
      .opacity(0.7)
      .mask(
        Color("BackgroundColor")
          .opacity((csManager.selectedTheme == .dark || (csManager.selectedTheme == nil && UITraitCollection.current.userInterfaceStyle == .dark)) ? 0.5 : 1)
      )
      .ignoresSafeArea()
    }
  }
}


struct TopGradientView: View {
  @Binding var selectedTab: String
  @EnvironmentObject var csManager: ColorSchemeManager
  var body: some View {
    GeometryReader { geometry in
      LinearGradient(gradient: Gradient(stops: [
        Gradient.Stop(color: getRightTabColor(tab: selectedTab), location: 0.1),
        Gradient.Stop(color: getTabColor(image: selectedTab), location: 0.5),
        Gradient.Stop(color: getLeftTabColor(tab: selectedTab), location: 1),
      ]), startPoint: .topTrailing, endPoint: .bottomLeading)
      .frame(height: geometry.size.height / 3)
      .opacity(0.7)
      .mask(
        Color("BackgroundColor")
          .opacity((csManager.selectedTheme == .dark || (csManager.selectedTheme == nil && UITraitCollection.current.userInterfaceStyle == .dark)) ? 0.5 : 1)
      )
      .ignoresSafeArea()
    }
  }
}

#Preview {
  TopGradientView(selectedTab: .constant("house"))
}
