//
//  CustomTabShape.swift
//  iRAK
//
//  Created by 90310013 on 4/14/24.
//

import SwiftUI

struct CustomTabShape: Shape {
  var xAxis: CGFloat
  var animatableData: CGFloat {
    get{return xAxis}
    set{xAxis = newValue}
  }
  func path(in rect: CGRect) -> Path {
    return Path { path in
      path.move(to: CGPoint(x: 0, y: 0))
      path.addLine(to: CGPoint(x: rect.width, y: 0))
      path.addLine(to: CGPoint(x: rect.width, y: rect.height))
      path.addLine(to: CGPoint(x: 0, y: rect.height))
      
      let center = xAxis
      
      path.move(to: CGPoint(x: center - 50 , y: 0))
      
      let to1 = CGPoint(x: center, y: 35)
      let control1 = CGPoint(x: center - 25, y: 0)
      let control2 = CGPoint(x: center - 25, y: 35)
      
      let to2 = CGPoint(x: center + 50, y: 0)
      let control3 = CGPoint(x: center + 25, y: 35)
      let control4 = CGPoint(x: center + 25, y: 0)
      
      path.addCurve(to: to1, control1: control1, control2: control2)
      path.addCurve(to: to2, control1: control3, control2: control4)
    }
  }
}
