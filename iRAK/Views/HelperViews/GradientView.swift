//
//  GradientView.swift
//  iRAK
//
//  Created by 90310013 on 4/16/24.
//

import SwiftUI

struct GradientView: View {
  @Binding var selectedTab: String
  @Environment(\.colorScheme) var cs
  var body: some View {
    GeometryReader { geometry in
      LinearGradient(gradient: Gradient(stops: [
        Gradient.Stop(color: getRightTabColor(tab: selectedTab), location: 0),
        Gradient.Stop(color: getTabColor(image: selectedTab), location: 0.5),
        Gradient.Stop(color: getLeftTabColor(tab: selectedTab), location: 1),
      ]), startPoint: .topTrailing, endPoint: .bottomLeading)
      .frame(height: geometry.size.height / 3)
      .mask(LinearGradient(gradient: Gradient(colors: [Color.backgroundColor, .clear]), startPoint: .top, endPoint: .bottom))
      .opacity((cs == .dark) ? 0.35 : 0.7)
      .ignoresSafeArea()
    }
  }
}

#Preview {
  GradientView(selectedTab: .constant(tabs[3]))
}
