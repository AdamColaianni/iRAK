//
//  WBJoinViewModel.swift
//  iRAK
//
//  Created by 90310013 on 5/9/24.
//

import SwiftUI
import Firebase

class WordBombJoinViewModel: ObservableObject {
  var currentUser = try? AuthenticationManager.shared.getAuthenticatedUser()
  @AppStorage("userName") var userName = "name"
  @Published var gameRoomCode: String = ""
  @Published var hasRoomEnded: Bool = false
  private let ref = Database.database().reference()
  private var refHandle: DatabaseHandle?
  private var playerRefHandle: DatabaseHandle?
  // Vars synced with database
  @Published var word: String = ""
  @Published var players: [String: String] = [:]
  
  deinit {
    leaveRoom()
  }
  
  func joinRoom(code: String, completion: @escaping (Bool) -> Void) {
    gameRoomExists(code: code) { exists in
      if exists {
        self.gameRoomCode = code
        
        self.addUserToRoom()
        self.observeRoomChanges()
        print("User joined room successfully")
        completion(true)
      } else {
        print("User failed to join room")
        completion(false)
      }
    }
  }
  
  private func observeRoomChanges() {
    refHandle = self.ref.child(self.gameRoomCode).child("word").observe(.value) { snapshot in
      if let word = snapshot.value as? String {
        self.word = word
      }
    }
    playerRefHandle = self.ref.child(self.gameRoomCode).child("players").observe(.value) { snapshot in
      if let playersDictionary = snapshot.value as? [String: String] {
        self.players = playersDictionary
      } else {
        // Ran when there is no longer detected data (aka the room has ended)
        self.hasRoomEnded = true
      }
    }
  }
  
  private func addUserToRoom() {
    self.ref.child(self.gameRoomCode).child("players").observeSingleEvent(of: .value, with: { snapshot in
      if var players = snapshot.value as? [String: Any] {
        // If there are already players, add the new player to the dictionary
        players[self.currentUser?.uid ?? ""] = self.userName
        self.ref.child(self.gameRoomCode).child("players").setValue(players)
      } else {
        // If there are no players yet, create a new dictionary with the new player. This should never happen though
        let players = [self.currentUser?.uid ?? "": self.userName]
        self.ref.child(self.gameRoomCode).child("players").setValue(players)
      }
    })
  }
  
  private func gameRoomExists(code: String, completion: @escaping (Bool) -> Void) {
    ref.child(code).observeSingleEvent(of: .value, with: { snapshot in
      completion(snapshot.exists())
    })
  }
  
  func leaveRoom() {
    if refHandle != nil {
      ref.child(self.gameRoomCode).child("players").child(self.currentUser?.uid ?? "").removeValue { error, _ in
        if let error = error {
          print("Failed to delete user from room: \(error.localizedDescription)")
        } else {
          print("User left room successfully.")
        }
      }
      ref.removeObserver(withHandle: refHandle!)
      ref.removeObserver(withHandle: playerRefHandle!)
    }
  }
  
  func updateWord(word: String) {
    ref.child(self.gameRoomCode).child("word").setValue(word)
  }
}
