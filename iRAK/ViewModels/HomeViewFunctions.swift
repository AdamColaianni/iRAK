//
//  UIFunctions.swift
//  iRAK
//
//  Created by 90310013 on 4/14/24.
//

import Foundation
import SwiftUI

var tabs = ["house", "archivebox", "bell", "message", "mic"]

func getTabColor(image: String) -> Color {
  switch image {
  case "house":
    return Color.green
  case "archivebox":
    return Color.blue
  case "bell":
    return Color.red
  case "message":
    return Color.yellow
  case "mic":
    return Color.purple
  default:
    return Color.gray
  }
}

func getTitle(sheetNum: String) -> String {
  switch sheetNum {
  case "house":
    return "Game 1 title"
  case "archivebox":
    return "Game 2 title"
  case "bell":
    return "Game 3 title"
  case "message":
    return "Game 4 title"
  case "mic":
    return "Game 5 title"
  default:
    return "title"
  }
}
