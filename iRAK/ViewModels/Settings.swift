//
//  Settings.swift
//  iRAK
//
//  Created by 90310013 on 4/17/24.
//

import SwiftUI

@MainActor
final class Settings: ObservableObject {
  @AppStorage("gradient") var isGradientShown: Bool = true
  @AppStorage("selectedProfilePhotoData") var selectedProfilePhotoData: Data?
  @AppStorage("userName") var userName = "name"
}
