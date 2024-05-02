//
//  AuthenticationManager.swift
//  iRAK
//
//  Created by 90310013 on 4/25/24.
//

import Foundation
import FirebaseAuth


// may not need
struct AuthDataResultModel {
  let uid: String
  let email: String?
  let photoUrl: URL?
  let isAnonymous: Bool
  
  init(user: User) {
    self.uid = user.uid
    self.email = user.email
    self.photoUrl = user.photoURL
    self.isAnonymous = user.isAnonymous
  }
}

final class AuthenticationManager {
  static let shared = AuthenticationManager()
  private init() { }
  
  func getAuthenticatedUser() throws -> AuthDataResultModel {
    guard let user = Auth.auth().currentUser else {
      throw URLError(.badServerResponse)
    }
    return AuthDataResultModel(user: user)
  }
  
  func signOut() throws {
    try Auth.auth().signOut()
  }
  
  func delete() async throws {
    guard let user = Auth.auth().currentUser else {
      throw URLError(.badURL)
    }
    
    try await user.delete()
  }
  
}

extension AuthenticationManager {
  @discardableResult
  func signInAnonymous() async throws -> AuthDataResultModel {
    let authDataResult = try await Auth.auth().signInAnonymously()
    print("signInAnonymous has run sucessfully")
    return AuthDataResultModel(user: authDataResult.user)
  }
}
