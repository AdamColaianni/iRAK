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
    VStack {
      ForEach(wordBomb.players.sorted(by: <), id: \.key) { id, name in
          Text("\(id): \(name)")
      }
      
      Text("You are the host. Code: \(wordBomb.gameRoomCode)")
      TextField("Type the word here", text: $typedWord)
        .focused($focusOnTextBox)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        .onChange(of: typedWord) { newValue in
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
      if gameRoomCode == "" {
        dismiss()
      }
    }
  }
}

#Preview {
  WordBombHostView()
}
