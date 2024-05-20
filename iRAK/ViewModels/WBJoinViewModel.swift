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
  @AppStorage("userName") var userName = "name"
  @Published var gameRoomCode: String = ""
  @Published var hasRoomEnded: Bool = false
  private let ref = Database.database().reference()
  private var refHandle: DatabaseHandle?
  private var playerRefHandle: DatabaseHandle?
  private let storage = Storage.storage()
  // Vars synced with database
  @Published var word: String = ""
  @Published var players: [String: String] = [:]
  @Published var profilePictures: [String:Data] = [:]
  
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
    refHandle = self.ref.child(self.gameRoomCode).child("word").observe(.value) { snapshot in
      if let word = snapshot.value as? String {
        self.word = word
      } else {
        // Ran when there is no longer detected data (aka the room has ended)
        self.hasRoomEnded = true
      }
    }
    playerRefHandle = self.ref.child(self.gameRoomCode).child("players").observe(.value) { snapshot in
      if let playersDictionary = snapshot.value as? [String: String] {
        if self.players != playersDictionary {
          self.players = playersDictionary
          self.updateProfilePictues()
        }
      }
    }
  }
  
  private func updateProfilePictues() {
    // If the user is no longer in the room
    for key in profilePictures.keys {
      if players[key] == nil {
        profilePictures.removeValue(forKey: key)
      }
    }
    
    for (userId, name) in players {
      // if the user is already in the room doesn't redownload the pic
      if userId == currentUser?.uid || profilePictures[userId] != nil {
        continue
      }
      downloadProfilePic(userId: userId) { profilePic in
        if let profilePic = profilePic {
          self.profilePictures[name] = profilePic
          print("Successfully added the profile picture to the list")
        } else {
          if let placeholderImage = UIImage(named: "x-symbol") {
            self.profilePictures[name] = placeholderImage.pngData()!
            print("added placeholder")
          }
        }
      }
    }
  }
  
  func downloadProfilePic(userId: String, completion: @escaping (Data?) -> Void) {
    let storageRef = storage.reference().child("profile_pics/\(userId).jpg")
    storageRef.getData(maxSize: 3 * 1024 * 1024) { data, error in
      if let error = error {
        print(error)
        completion(nil)
      } else {
        completion(data)
      }
    }
  }
  
  private func addUserToRoom(completion: @escaping (Bool) -> Void) {
    self.ref.child(self.gameRoomCode).child("players").observeSingleEvent(of: .value, with: { snapshot in
      if var players = snapshot.value as? [String: Any] {
        // If there are already players, add the new player to the dictionary
        players[self.currentUser?.uid ?? ""] = self.userName
        self.ref.child(self.gameRoomCode).child("players").setValue(players) { error, _ in
          // Call the completion handler with false if the player was added successfully
          completion(error == nil)
        }
      } else {
        // This should be executed when the game is in session, so don't let them join
        completion(false)
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
