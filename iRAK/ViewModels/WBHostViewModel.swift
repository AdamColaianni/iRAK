//
//  WordBombViewModel.swift
//  iRAK
//
//  Created by 90310013 on 5/7/24.
//

import SwiftUI
import Firebase
import FirebaseStorage

class WordBombHostViewModel: ObservableObject {
  var currentUser = try? AuthenticationManager.shared.getAuthenticatedUser()
  private let ref = Database.database().reference()
  private var refHandle: DatabaseHandle?
  private var playerRefHandle: DatabaseHandle?
  @Published var gameRoomCode: String = generateCode()
  @AppStorage("userName") var userName = "name"
  private let storage = Storage.storage()
  // Vars synced with database
  @Published var word: String = ""
  @Published var players: [String: String] = [:]
  @Published var profilePictures: [String:Data] = [:]
  
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
