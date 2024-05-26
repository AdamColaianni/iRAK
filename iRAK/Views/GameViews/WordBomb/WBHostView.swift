//
//  WordBombView.swift
//  iRAK
//
//  Created by 90310013 on 5/3/24.
//

import SwiftUI

struct WordBombHostView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject private var wordBomb = WordBombHostViewModel()
  @State var typedWord: String = ""
  @FocusState var focusOnTextBox: Bool
  
  var body: some View {
    ZStack {
      Color.backgroundColor
        .ignoresSafeArea()
      VStack {
        ProfilePicturesScrollView(profilePictures: $wordBomb.players)
        
        if wordBomb.yourTurn {
          Text("YOUR TURN!!")
        }
        
        Button {
          print(wordBomb.players)
        } label: {
          Text("Print")
        }
        
        Button {
          wordBomb.startGame()
        } label: {
          Text("Start Game")
            .padding()
            .background(Color.midgroundColor)
            .foregroundColor(.primary)
            .cornerRadius(15)
            .shadow(radius: 3)
            .font(.system(size: 15))
            .padding()
        }
        
        Text("You are the host. Code: \(wordBomb.gameRoomCode)")
        TextField("Type the word here", text: $typedWord)
          .focused($focusOnTextBox)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding()
          .onChange(of: typedWord) { _, newValue in
            wordBomb.updateWord(word: newValue)
          }
        
        Text("Word: \(wordBomb.word)")
          .padding()
      }
      .onAppear {
        focusOnTextBox = true
      }
      .onDisappear {
        wordBomb.deleteRoom() // MEHHH
        focusOnTextBox = false
      }
      .onReceive(wordBomb.$gameRoomCode) { gameRoomCode in
        if gameRoomCode == "" { // gross (for the room ending)
          dismiss()
        }
      }
    }
  }
}

#Preview {
  WordBombHostView()
}
