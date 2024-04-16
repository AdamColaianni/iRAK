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
    return Color.red
  case "archivebox":
    return Color.yellow
  case "bell":
    return Color.green
  case "message":
    return Color.blue
  case "mic":
    return Color.purple
  default:
    return Color.gray
  }
}

func getTitle(sheetNum: String) -> String {
  switch sheetNum {
  case "house":
    return "Word Bomb"
  case "archivebox":
    return "Trivia Trench"
  case "bell":
    return "Heads Up!!!"
  case "message":
    return "War-dle"
  case "mic":
    return "Sniper Trainer"
  default:
    return "Title"
  }
}

func getLeftTabColor(tab: String) -> Color {
  switch tab {
  case "house":
    return .purple
  case "archivebox":
    return .red
  case "bell":
    return .yellow
  case "message":
    return .green
  case "mic":
    return .blue
  default:
    return .clear
  }
}

func getRightTabColor(tab: String) -> Color {
  switch tab {
  case "house":
    return .yellow
  case "archivebox":
    return .green
  case "bell":
    return .blue
  case "message":
    return .purple
  case "mic":
    return .red
  default:
    return .clear
  }
}

  
  
  
  
