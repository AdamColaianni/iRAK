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
  
  var body: some View {
    VStack {
      Text("Code: \(wordBomb.gameRoomCode)")
      TextField("Type the word here", text: $typedWord)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        .onChange(of: typedWord) { newValue in
          wordBomb.updateWord(word: newValue)
        }
      
      Text("Word: \(wordBomb.word)")
        .padding()
    }
    .onDisappear {
      wordBomb.deleteRoom() // MEHHH
    }
    .onReceive(wordBomb.$gameRoomCode) { gameRoomCode in
      if gameRoomCode == "" {
        dismiss()
      }
    }
  }
}

#Preview {
  WordBombHostView()
}
