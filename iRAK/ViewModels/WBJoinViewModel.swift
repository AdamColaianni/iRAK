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
  private let ref = Database.database().reference()
  private var refHandle: DatabaseHandle?
  // Vars synced with database
  @Published var word: String = ""
  
  deinit {
    leaveRoom()
  }
  
  func joinRoom(code: String, completion: @escaping (Bool) -> Void) {
    gameRoomExists(code: code) { exists in
      if exists {
        self.gameRoomCode = code
        
        self.addUserToRoom()
        self.observeRoomChanges()
        
        completion(true)
      } else {
        completion(false)
      }
    }
  }
  
  private func observeRoomChanges() {
    self.refHandle = self.ref.child(self.gameRoomCode).child("word").observe(.value) { snapshot in
      if let word = snapshot.value/*(forKey: "word")*/ as? String {
        self.word = word
      }
      // if there is no current player data in a listener , leave the room and dismiss the view on other phones. This is so that if the hoster ends the room everyone leaves
      // observe players as well
    }
  }
  
  private func addUserToRoom() {
    self.ref.child(self.gameRoomCode).child("players").observeSingleEvent(of: .value, with: { snapshot in
      if var players = snapshot.value as? [String: Any] {
        // If there are already players, add the new player to the dictionary
        players[self.currentUser?.uid ?? ""] = self.userName
        self.ref.child(self.gameRoomCode).child("players").setValue(players)
      } else {
        // If there are no players yet, create a new dictionary with the new player
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
    }
  }
  
  func updateWord(word: String) {
    ref.child(self.gameRoomCode).child("word").setValue(word)
  }
}
