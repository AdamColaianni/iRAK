//
//  Settings.swift
//  iRAK
//
//  Created by 90310013 on 4/17/24.
//

import SwiftUI

final class Settings: ObservableObject {
  @AppStorage("gradient") static var isGradientShown: Bool = true
  @AppStorage("selectedProfilePhotoData") static var selectedProfilePhotoData: Data?
  @AppStorage("userName") static var userName = "name"
}
