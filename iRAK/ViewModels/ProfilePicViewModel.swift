//
//  SettingsViewModel.swift
//  iRAK
//
//  Created by 90310013 on 5/13/24.
//

import SwiftUI
import FirebaseStorage

class ProfilePicViewModel: ObservableObject {
  @Published var profilePic: Data?
  @Published var isLoading = false
  @Published var error: Error?
  
  private let maxSize: Int = 3 * 1024 * 1024
  private let storage = Storage.storage()
  private var userId: String
  
  init(userId: String) {
    self.userId = userId
  }
  
  func uploadProfilePic(data: Data) {
    // Check if the data exceeds the size limit
    guard data.count <= maxSize else {
      // Handle the error for file size exceeding limit
      self.error = NSError(domain: "", code: 413, userInfo: [NSLocalizedDescriptionKey: "File size exceeds the 3 MB limit."])
      return
    }
    
    isLoading = true
    let storageRef = storage.reference().child("profile_pics/\(userId).jpg")
    storageRef.putData(data, metadata: nil) { [weak self] metadata, error in
      guard let self = self else { return }
      self.isLoading = false
      if let error = error {
        self.error = error
      } else {
        storageRef.getData(maxSize: Int64(maxSize)) { data, error in
          if let error = error {
            self.error = error
          } else {
            self.profilePic = data
          }
        }
      }
    }
  }
  
  func deleteProfilePic() {
    isLoading = true
    let storageRef = storage.reference().child("profile_pics/\(userId).jpg")
    storageRef.delete { [weak self] error in
      guard let self = self else { return }
      self.isLoading = false
      if let error = error {
        self.error = error
      } else {
        self.profilePic = nil
      }
    }
  }
  
  func updateUserId(userId: String) {
    self.userId = userId
  }
  
}
