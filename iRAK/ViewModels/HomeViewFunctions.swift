//
//  UIFunctions.swift
//  iRAK
//
//  Created by 90310013 on 4/14/24.
//

import Foundation
import SwiftUI

var tabs = ["bomb", "trench", "headsup", "wardle", "training"]

func getTabImage(tab: String) -> Image {
  switch tab {
  case "bomb":
    return Image("bomb-symbol")
  case "trench":
    return Image("question-symbol")
  case "headsup":
    return Image("fire-symbol")
  case "wardle":
    return Image("text-symbol")
  case "training":
    return Image("clock-symbol")
  default:
    return Image("")
  }
}

func getTabColor(image: String) -> Color {
  switch image {
  case "bomb":
    return Color.red
  case "trench":
    return Color.yellow
  case "headsup":
    return Color.green
  case "wardle":
    return Color.blue
  case "training":
    return Color.purple
  default:
    return Color.gray
  }
}

func getTitle(sheetNum: String) -> String {
  switch sheetNum {
  case "bomb":
    return "Word Bomb"
  case "trench":
    return "Trivia Trench"
  case "headsup":
    return "Heads Up!!!"
  case "wardle":
    return "War-dle"
  case "training":
    return "Sniper Trainer"
  default:
    return "Title"
  }
}

func getLeftTabColor(tab: String) -> Color {
  switch tab {
  case "bomb":
    return .purple
  case "trench":
    return .red
  case "headsup":
    return .yellow
  case "wardle":
    return .green
  case "training":
    return .blue
  default:
    return .clear
  }
}

func getRightTabColor(tab: String) -> Color {
  switch tab {
  case "bomb":
    return .yellow
  case "trench":
    return .green
  case "headsup":
    return .blue
  case "wardle":
    return .purple
  case "training":
    return .red
  default:
    return .clear
  }
}
