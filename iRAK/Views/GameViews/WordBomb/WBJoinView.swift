//
//  WordBombJoinView.swift
//  iRAK
//
//  Created by 90310013 on 5/7/24.
//

import SwiftUI

struct WordBombJoinView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject private var wordBomb = WordBombJoinViewModel()
  @State var gameRoomCode: String = ""
  @State private var isJoinPresented = true
  @State private var isCodeWrong = false
  @FocusState var focusOnCodeTextBox: Bool
  @FocusState var focusOnMessageTextBox: Bool
  // Vars synced with database
  @State var typedWord: String = ""

  var body: some View {
    ZStack {
      Color.backgroundColor
        .ignoresSafeArea()
      VStack {
        
        //        ProfilePicturesScrollView(profilePictures: $wordBomb.players)
        Text("Letters: \(wordBomb.letters)")
          .padding()
        
        if wordBomb.isItMyTurn {
          Text("IT'S YOUR TURN!!!")
        }
        
        Text(wordBomb.gameRoomCode)
          .font(.system(size: 25))
          .padding()
        
        TextField("Type the word here", text: $typedWord)
          .focused($focusOnMessageTextBox)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding()
          .onChange(of: typedWord) { _, newValue in
            wordBomb.updateWord(word: newValue)
          }
        
        Text("Word: \(wordBomb.word.trimmingCharacters(in: CharacterSet(charactersIn: "~")))")
          .padding()
      }
      .disabled(isJoinPresented || wordBomb.hasRoomEnded)
      .blur(radius: (isJoinPresented || wordBomb.hasRoomEnded) ? 3 : 0)
      
      if isJoinPresented {
        ZStack {
          Color.black.opacity(0.2)
            .edgesIgnoringSafeArea(.all)
          VStack {
            Text("Enter Code")
              .font(.system(size: 35, weight: .bold, design: .rounded))
            
            if isCodeWrong {
              Text("Invalid game code")
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(.red)
            }
            
            TextField("Enter code", text: $gameRoomCode) {
              joinRoom()
            }
            .focused($focusOnCodeTextBox)
            .autocapitalization(.allCharacters)
            .disableAutocorrection(true)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .onChange(of: gameRoomCode) { _, _ in
              isCodeWrong = false
              if gameRoomCode.count > 4 {
                gameRoomCode = String(gameRoomCode.prefix(4))
              }
            }
            
            Button(action: {
              joinRoom()
            }) {
              Text("Submit")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.foregroundColor)
                .clipShape(Capsule())
                .shadow(radius: 1)
            }
          }
          .padding()
          .frame(maxWidth: 300, maxHeight: 300)
          .background(Color.midgroundColor)
          .foregroundColor(.primary)
          .clipShape(Rectangle())
          .cornerRadius(50)
          .shadow(radius: 3)
          .padding(5)
        }
      }
      
      if wordBomb.hasRoomEnded {
        ZStack {
          Color.black.opacity(0.2)
            .edgesIgnoringSafeArea(.all)
          VStack {
            Text("Game has ended")
              .font(.system(size: 30, weight: .bold, design: .rounded))
            
            Button(action: {
              dismiss()
            }) {
              Text("Leave game")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.foregroundColor)
                .clipShape(Capsule())
                .shadow(radius: 1)
            }
          }
          .padding()
          .frame(maxWidth: 300, maxHeight: 300)
          .background(Color.midgroundColor)
          .foregroundColor(.primary)
          .clipShape(Rectangle())
          .cornerRadius(50)
          .shadow(radius: 3)
          .padding()
        }
      }
    }
    .onAppear {
      focusOnCodeTextBox = true
    }
    .onDisappear {
      wordBomb.leaveRoom()
    }
  }
  
  func joinRoom() {
    if gameRoomCode != "" {
      wordBomb.joinRoom(code: gameRoomCode) { roomExists in
        if roomExists {
          withAnimation {
            // Game room exists, perform further actions
            self.isJoinPresented = false
            focusOnMessageTextBox = true
          }
        } else {
          withAnimation {
            // Game room does not exist, handle appropriately
            // For example, show an alert or take some other action
            isCodeWrong = true
          }
        }
      }
    }
  }
}

#Preview {
  WordBombJoinView()
}
