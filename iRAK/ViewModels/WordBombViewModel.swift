//
//  WordBombViewModel.swift
//  iRAK
//
//  Created by 90310013 on 5/7/24.
//

import SwiftUI
import Firebase

class WordBombViewModel: ObservableObject {
  var currentUser = try? AuthenticationManager.shared.getAuthenticatedUser()
  private let ref = Database.database().reference().child("gameRoom").child("word")
  private var refHandle: DatabaseHandle?
  @Published var word: String = ""
  
  init() {
    observeWord()
  }
  
  deinit {
    cleanUp()
  }
  
  func generateCode() -> String {
    let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let randomString = String((0..<4).map{ _ in letters.randomElement()! })
    return randomString
  }
  
  func cleanUp() {
    let gameRoomRef = ref.parent! // parent not needed when I don't have .child("gameRoom").child("word") in the class vars
    gameRoomRef.removeValue { error, _ in
      if let error = error {
        print("Failed to delete gameRoom node: \(error.localizedDescription)")
      } else {
        print("gameRoom node deleted successfully.")
      }
    }
    ref.removeObserver(withHandle: refHandle!)
  }
  
  // Function to update the word in the database
  func updateWord(word: String) {
    ref.setValue(word)
  }
  
  // Function to observe changes to the word in the database
  private func observeWord() {
    refHandle = ref.observe(.value) { snapshot in
      if let word = snapshot.value as? String {
        self.word = word
      }
    }
  }
}
