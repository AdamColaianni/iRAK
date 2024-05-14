//
//  WordBombViewModel.swift
//  iRAK
//
//  Created by 90310013 on 5/7/24.
//

import SwiftUI
import Firebase

class WordBombHostViewModel: ObservableObject {
  var currentUser = try? AuthenticationManager.shared.getAuthenticatedUser()
  private let ref = Database.database().reference()
  private var refHandle: DatabaseHandle?
  private var playerRefHandle: DatabaseHandle?
  @Published var gameRoomCode: String = generateCode()
  @AppStorage("userName") var userName = "name"
  // Vars synced with database
  @Published var word: String = ""
  @Published var players: [String: String] = [:]
  
  init() {
    createGameRoom()
  }
  
  deinit {
    deleteRoom()
  }
  
  private func createGameRoom(recursionDepth: Int = 0) {
    guard recursionDepth < 15 else {
      // Stop recursion after 15 attempts
      print("Game room code not found within 15 tries")
      self.gameRoomCode = ""
      return
    }
    gameRoomExists(code: self.gameRoomCode) { exists in
      if !exists {
        // Set player and word
        self.ref.child(self.gameRoomCode).child("players").setValue([self.currentUser?.uid: self.userName])
        self.ref.child(self.gameRoomCode).child("word").setValue("")
        
        self.observeRoom()
        print("gameRoom node successfully created")
      } else {
        print("Duplicated code found, trying again . . .")
        self.gameRoomCode = WordBombHostViewModel.generateCode()
        self.createGameRoom(recursionDepth: recursionDepth + 1)
      }
    }
  }
  
  private func observeRoom() {
    refHandle = ref.child(self.gameRoomCode).child("word").observe(.value) { snapshot in
      if let word = snapshot.value as? String {
        self.word = word
      }
    }
    playerRefHandle = self.ref.child(self.gameRoomCode).child("players").observe(.value) { snapshot in
      if let playersDictionary = snapshot.value as? [String: String] {
        self.players = playersDictionary
      }
    }
  }
  
  private func gameRoomExists(code: String, completion: @escaping (Bool) -> Void) {
    ref.child(self.gameRoomCode).observeSingleEvent(of: .value, with: { snapshot in
      completion(snapshot.exists())
    })
  }
  
  func deleteRoom() {
    if self.gameRoomCode == "" {
      return
    }
    ref.child(self.gameRoomCode).removeValue { error, _ in
      if let error = error {
        print("Failed to delete gameRoom node: \(error.localizedDescription)")
      } else {
        print("gameRoom node deleted successfully.")
      }
    }
    ref.removeObserver(withHandle: playerRefHandle!)
    ref.removeObserver(withHandle: refHandle!)
  }
  
  func updateWord(word: String) {
    ref.child(self.gameRoomCode).child("word").setValue(word)
  }
  
  static private func generateCode() -> String {
    let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    return String((0..<4).map{ _ in letters.randomElement()! })
  }
}
