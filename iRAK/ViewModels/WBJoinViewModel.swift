//
//  WBJoinViewModel.swift
//  iRAK
//
//  Created by 90310013 on 5/9/24.
//

import SwiftUI
import Firebase
import FirebaseStorage

class WordBombJoinViewModel: ObservableObject {
  var currentUser = try? AuthenticationManager.shared.getAuthenticatedUser()
  private let ref = Database.database().reference()
  private var wordRefHandle: DatabaseHandle?
  private var letterRefHandle: DatabaseHandle?
  private var cplayerRefHandle: DatabaseHandle?
  private var playersChanRefHandle: DatabaseHandle?
  private var playersAddedRefHandle: DatabaseHandle?
  private var playersDelRefHandle: DatabaseHandle?
  @AppStorage("userName") var userName = "name"
  @AppStorage("selectedProfilePhotoData") var selectedProfilePhotoData: Data?
  @Published var gameRoomCode: String = ""
  @Published var hasRoomEnded: Bool = false
  @Published var gameFinished: Bool = false
  @Published var yourTurn: Bool = false
  // Vars synced with database
  @Published var letters: String = ""
  @Published var word: String = ""
  @Published var cplayer: String = ""
  @Published var players: [PlayerData] = []
  
  deinit {
    leaveRoom()
  }
  
  func joinRoom(code: String, completion: @escaping (Bool) -> Void) {
    gameRoomExists(code: code) { exists in
      if exists {
        self.gameRoomCode = code
        
        self.addUserToRoom { success in
          if success {
            self.observeRoomChanges()
            print("User joined room successfully")
            completion(true)
          } else {
            print("Room has already started")
            completion(false)
          }
        }
      } else {
        print("User failed to join room")
        completion(false)
      }
    }
  }
  
  private func observeRoomChanges() {
    wordRefHandle = self.ref.child(self.gameRoomCode).child("word").observe(.value) { snapshot in
      if let word = snapshot.value as? String {
        self.word = word
      } else {
        // Ran when there is no longer detected data (aka the room has ended)
        self.hasRoomEnded = true
      }
    }
    
    playersAddedRefHandle = ref.child(self.gameRoomCode).child("players").observe(.childAdded) { snapshot in
      if let playerData = snapshot.value as? [Any],
         playerData.count == 2,
         let name = playerData[0] as? String,
         let lives = playerData[1] as? Int {
        
        // Set profile image
        if snapshot.key != self.currentUser?.uid {
          WordBombHostViewModel.downloadProfilePic(userId: snapshot.key) { profilePic in
            let player = PlayerData(uid: snapshot.key, name: name, lives: lives, profileImageData: profilePic)
            self.players.append(player)
          }
        } else {
          let player = PlayerData(uid: snapshot.key, name: name, lives: lives, profileImageData: self.selectedProfilePhotoData)
          self.players.append(player)
        }
      }
    }
    
    playersDelRefHandle = ref.child(self.gameRoomCode).child("players").observe(.childRemoved) { snapshot in
      var removeIndex = -1
      for (index, player) in self.players.enumerated() {
        if player.uid == snapshot.key {
          removeIndex = index
          break
        }
      }
      if removeIndex != -1 {
        self.players.remove(at: removeIndex)
        print("Player removed: \(snapshot.key)")
      }
    }
    
    playersChanRefHandle = ref.child(self.gameRoomCode).child("players").observe(.value) { snapshot in
      for child in snapshot.children {
        if let snapshot = child as? DataSnapshot,
           let playerData = snapshot.value as? [Any],
           playerData.count == 2,
           let lives = playerData[1] as? Int {
          let uid = snapshot.key
          for (index, dataPlayer) in self.players.enumerated() {
            if dataPlayer.uid == uid {
              self.players[index].lives = lives
            }
          }
        }
      }
    }
    
    // game has begun
    cplayerRefHandle = ref.child(self.gameRoomCode).child("cplayer").observe(.value) { snapshot in
      if let currentPlayer = snapshot.value as? String {
        self.cplayer = currentPlayer
        if currentPlayer == self.currentUser?.uid {
          self.yourTurn = true
        } else {
          self.yourTurn = false
        }
      }
    }
    letterRefHandle = self.ref.child(self.gameRoomCode).child("letters").observe(.value) { snapshot in
      if let letters = snapshot.value as? String {
        self.letters = letters
        if letters == "DONE" {
          self.gameFinished = true
          // if self.yourTurn {
          // You won
          // } else {
          // someone else won
          // }
        }
      }
    }
  }
  
  func submit() {
    ref.child(self.gameRoomCode).child("word").setValue(word + "~")
  }
  
  private func addUserToRoom(completion: @escaping (Bool) -> Void) {
    self.ref.child(self.gameRoomCode).child("cplayer").observeSingleEvent(of: .value, with: { snapshot in
      if snapshot.exists() {
        // This should be executed when the game is in session, so don't let them join
        print("Can't join room, game is in session")
        completion(false)
      } else {
        // Only proceed if the game is not in session
        self.ref.child(self.gameRoomCode).child("players").observeSingleEvent(of: .value, with: { snapshot in
          if var players = snapshot.value as? [String: Any] {
            // If there are already players, add the new player to the dictionary
            players[self.currentUser?.uid ?? ""] = [self.userName, 2]
            self.ref.child(self.gameRoomCode).child("players").setValue(players) { error, _ in
              // Call the completion handler with true if the player was added successfully
              completion(error == nil)
            }
          }
        })
      }
    })
  }
  
  func updateWord(word: String) {
    ref.child(self.gameRoomCode).child("word").setValue(word)
  }
  
  private func gameRoomExists(code: String, completion: @escaping (Bool) -> Void) {
    ref.child(code).observeSingleEvent(of: .value, with: { snapshot in
      completion(snapshot.exists())
    })
  }
  
  func leaveRoom() {
    if wordRefHandle != nil {
      ref.child(self.gameRoomCode).child("players").child(self.currentUser?.uid ?? "").removeValue { error, _ in
        if let error = error {
          print("Failed to delete user from room: \(error.localizedDescription)")
        } else {
          print("User left room successfully.")
        }
      }
      ref.removeObserver(withHandle: wordRefHandle!)
      ref.removeObserver(withHandle: letterRefHandle!)
      ref.removeObserver(withHandle: cplayerRefHandle!)
      ref.removeObserver(withHandle: playersChanRefHandle!)
      ref.removeObserver(withHandle: playersAddedRefHandle!)
      ref.removeObserver(withHandle: playersDelRefHandle!)
    }
  }
}
