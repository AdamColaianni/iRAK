//
//  WordBombViewModel.swift
//  iRAK
//
//  Created by 90310013 on 5/7/24.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct PlayerData: Identifiable, Equatable {
  var id: String { uid }
  var uid: String
  var name: String
  var lives: Int
  var profileImageData: Data
  static func == (lhs: PlayerData, rhs: PlayerData) -> Bool {
    return lhs.uid == rhs.uid
  }
}

class WordBombHostViewModel: ObservableObject {
  var currentUser = try? AuthenticationManager.shared.getAuthenticatedUser()
  private let ref = Database.database().reference()
  private var wordRefHandle: DatabaseHandle?
  private var lettersRefHandle: DatabaseHandle?
  private var cplayerRefHandle: DatabaseHandle?
  private var playersChanRefHandle: DatabaseHandle?
  private var playersAddedRefHandle: DatabaseHandle?
  private var playersDelRefHandle: DatabaseHandle?
  private var playerIndex: Int = 0
  @Published var gameFinished = false
  @Published var gameStarted = false
  @Published var yourTurn: Bool = false
  @Published var gameRoomCode: String = generateCode()
  @AppStorage("userName") var userName = "name"
  @AppStorage("selectedProfilePhotoData") var selectedProfilePhotoData: Data?
  var timer: Timer?
  // Vars synced with database
  @Published var word: String = ""
  @Published var letters: String = ""
  @Published var cplayer: String = ""
  @Published var players: [PlayerData] = []
  
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
        self.ref.child(self.gameRoomCode).child("players").setValue([self.currentUser?.uid: [self.userName, 2]])
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
    // Word observer
    wordRefHandle = ref.child(self.gameRoomCode).child("word").observe(.value) { snapshot in
      if let word = snapshot.value as? String {
        self.word = word
        if word.contains("~") {
          self.verifyWord(for: word)
        }
      }
    }
    
    playersAddedRefHandle = ref.child(self.gameRoomCode).child("players").observe(.childAdded) { snapshot in
      if let playerData = snapshot.value as? [Any],
         playerData.count == 2,
         let name = playerData[0] as? String,
         let lives = playerData[1] as? Int {
        
        // Set profile image
        var data: Data = Data()
        if snapshot.key != self.currentUser?.uid {
          WordBombHostViewModel.downloadProfilePic(userId: snapshot.key) { profilePic in
            if let profilePic = profilePic {
              data = profilePic
            } else {
              if let placeholderImage = UIImage(named: "x-symbol") {
                data = placeholderImage.pngData()!
              }
            }
            let player = PlayerData(uid: snapshot.key, name: name, lives: lives, profileImageData: data)
            self.players.append(player)
            print("ADDED PLAYER")
            print(player)
          }
        } else {
          if self.selectedProfilePhotoData != nil {
            data = self.selectedProfilePhotoData!
            let player = PlayerData(uid: snapshot.key, name: name, lives: lives, profileImageData: data)
            self.players.append(player)
            print("ADDED PLAYER")
            print(player)
          }
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
      self.players.remove(at: removeIndex)
      print("Player removed: \(snapshot.key)")
    }
    
    playersChanRefHandle = ref.child(self.gameRoomCode).child("players").observe(.value) { snapshot in
      for child in snapshot.children {
        if let snapshot = child as? DataSnapshot,
           let playerData = snapshot.value as? [Any],
           playerData.count == 2,
           let name = playerData[0] as? String,
           let lives = playerData[1] as? Int {
          let uid = snapshot.key
          let player = PlayerData(uid: uid, name: name, lives: lives, profileImageData: Data())
          
          for (index, dataPlayer) in self.players.enumerated() {
            if dataPlayer == player {
              self.players[index].lives = player.lives
            }
          }
          print("Changed players: \(player)")
        }
      }
    }
  }
  
  static func downloadProfilePic(userId: String, completion: @escaping (Data?) -> Void) {
    let storageRef = Storage.storage().reference().child("profile_pics/\(userId).jpg")
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
  
  func observeStart() {
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
    lettersRefHandle = ref.child(self.gameRoomCode).child("letters").observe(.value) { snapshot in
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
  
  func changeTurn() {
    if self.players.count == 0 {
      return
    }
    self.setTurn(setPlayer: self.players[playerIndex % self.players.count].uid)
    self.writeLetters(letters: Global.doubleLetters.randomElement()!)
  }
  
  func submit() {
    ref.child(self.gameRoomCode).child("word").setValue(word + "~")
  }
  
  func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { _ in
      self.decrementLife(for: self.players[self.playerIndex % self.players.count].uid) {
        if self.isOnlyOnePlayerAlive() {
          self.setWinner()
          self.writeLetters(letters: "DONE")
          self.timer?.invalidate()
        } else {
          self.playerIndex += 1
          self.changeTurn()
        }
      }
    }
  }
  
  func resetTimer() {
    self.timer?.invalidate()
    self.startTimer()
  }
  
  func startGame() {
    if players.count == 1 {
      return
    }
    gameStarted = true
    
    observeStart()
    changeTurn()
    startTimer()
  }
  
  func verifyWord(for word: String) {
    let word = String(word.replacingOccurrences(of: "~", with: "")).lowercased()
    if word.count > 2 && word.contains(self.letters) && UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word) {
      self.playerIndex += 1
      changeTurn()
      resetTimer()
    }
  }
  
  func isOnlyOnePlayerAlive() -> Bool {
    let alivePlayers = players.filter { $0.lives > 0 }
    return alivePlayers.count == 1
  }
  
  func setWinner() {
    let alivePlayers = players.filter { $0.lives > 0 }
    if alivePlayers.count == 1 {
      setTurn(setPlayer: alivePlayers[0].uid)
    }
  }
  
  private func decrementLife(for playerUID: String, completion: @escaping () -> Void) {
    self.ref.child(self.gameRoomCode).child("players").child(playerUID).child("1").runTransactionBlock { currentData in
      if var currentValue = currentData.value as? Int {
        currentValue -= 1
        currentData.value = currentValue
      }
      return TransactionResult.success(withValue: currentData)
    } andCompletionBlock: { error, committed, snapshot in
      if committed {
        completion()
      }
    }
  }
  
  private func setTurn(setPlayer: String) {
    self.ref.child(self.gameRoomCode).child("cplayer").observeSingleEvent(of: .value, with: { snapshot in
      self.ref.child(self.gameRoomCode).child("cplayer").setValue(setPlayer) { error, _ in
        if error != nil {
          print(error!.localizedDescription)
        }
      }
    })
  }
  
  private func writeLetters(letters: String) {
    self.ref.child(self.gameRoomCode).child("letters").observeSingleEvent(of: .value, with: { snapshot in
      self.ref.child(self.gameRoomCode).child("letters").setValue(letters) { error, _ in
        if error != nil {
          print(error!.localizedDescription)
        }
      }
    })
  }
  
  func updateWord(word: String) {
    ref.child(self.gameRoomCode).child("word").setValue(word)
  }
  
  func deleteRoom() {
    if self.gameRoomCode == "" {
      return
    }
    timer?.invalidate()
    
    ref.removeObserver(withHandle: wordRefHandle!)
    ref.removeObserver(withHandle: playersChanRefHandle!)
    ref.removeObserver(withHandle: playersDelRefHandle!)
    ref.removeObserver(withHandle: playersAddedRefHandle!)
    
    if cplayer != "" {
      ref.removeObserver(withHandle: lettersRefHandle!)
      ref.removeObserver(withHandle: cplayerRefHandle!)
    }
    
    ref.child(self.gameRoomCode).removeValue { error, _ in
      if let error = error {
        print("Failed to delete gameRoom node: \(error.localizedDescription)")
      } else {
        print("gameRoom node deleted successfully.")
      }
    }
  }
  
  static private func generateCode() -> String {
    let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    return String((0..<4).map{ _ in letters.randomElement()! })
  }
}
