//
//  WordBombView.swift
//  iRAK
//
//  Created by 90310013 on 5/3/24.
//

import SwiftUI
import ConfettiSwiftUI

extension ZStack {
  func style() -> some View {
    self
    
  }
}

struct WordBombHostView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject private var wordBomb = WordBombHostViewModel()
  @State var typedWord: String = ""
  @FocusState var focusOnTextBox: Bool
  @State private var counter: Int = 0
  @State private var winningPlayerName: String = ""
  
  var body: some View {
    ZStack {
      Color.backgroundColor
        .ignoresSafeArea()
      VStack {
        VStack {
          Text("Code: ***\(wordBomb.gameRoomCode)***")
            .font(.system(size: 25))
          if !wordBomb.gameStarted {
            Button {
              wordBomb.startGame()
            } label: {
              Text("Start")
                .padding()
                .background(Color.foregroundColor)
                .foregroundColor(.primary)
                .cornerRadius(15)
                .shadow(radius: 3)
                .font(.system(size: 30))
            }
          } else {
            Text(wordBomb.letters.isEmpty ? "--" : wordBomb.letters)
              .font(.system(size: 45))
          }
        }
        .padding()
        .padding(.horizontal, 40)
        .background(Color.midgroundColor)
        .foregroundColor(.primary)
        .cornerRadius(10)
        .shadow(radius: 5)
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(Color.primary, lineWidth: 2)
        )
        .padding()
        
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 10) {
            ForEach(0..<wordBomb.players.count, id: \.self) { index in
              VStack {
                if let imageData = wordBomb.players[index].profileImageData, let uiImage = UIImage(data: imageData) {
                  Image(uiImage: uiImage)
                    .profileImageStyle(width: 70, height: 70)
                } else {
                  Image(systemName: "person.circle")
                    .profileImageStyle(width: 70, height: 70)
                }
                
                Text("\(wordBomb.players[index].name)")
                  .font(.system(size: 17))
                  .multilineTextAlignment(.center)
                Text("\(String(repeating: "❤️", count: wordBomb.players[index].lives))")
                  .font(.system(size: 17))
                  .multilineTextAlignment(.center)
              }
              .padding()
              .padding(.horizontal, 5)
              .background(
                RoundedRectangle(cornerRadius: 10)
                  .stroke(wordBomb.players[index].uid == wordBomb.cplayer ? Color.red : Color.primary, lineWidth: 2)
              )
              .background(Color.midgroundColor)
            }
          }
          .padding()
        }
        
        CustomTextField(placeholder: "Type the word here", text: $typedWord, isYourTurn: $wordBomb.yourTurn, word: wordBomb.word.trimmingCharacters(in: CharacterSet(charactersIn: "~"))) {
          wordBomb.submit()
        }
        .focused($focusOnTextBox)
        .autocorrectionDisabled()
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        .onChange(of: typedWord) { _, newValue in
          wordBomb.updateWord(word: newValue)
        }
        .disabled(!wordBomb.yourTurn)
        .frame(maxHeight: 44)
        .padding(.vertical, 10)
        .padding(.horizontal, 30)
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(Color.primary, lineWidth: 2)
        )
        .background(Color.midgroundColor)
        .padding()
        
        Spacer()
      }
      .disabled(wordBomb.gameFinished)
      .blur(radius: (wordBomb.gameFinished) ? 3 : 0)
      
      if wordBomb.gameFinished {
        ZStack {
          Color.black.opacity(0.2)
            .edgesIgnoringSafeArea(.all)
          VStack {
            if wordBomb.yourTurn {
              Text("YOU WON!!!")
                .font(.system(size: 30, weight: .bold, design: .rounded))
            } else {
              Text("Game has ended")
                .font(.system(size: 30, weight: .bold, design: .rounded))
              Text("\(winningPlayerName) won")
                .onAppear {
                  if let index = wordBomb.players.firstIndex(where: { $0.uid == wordBomb.cplayer }) {
                    winningPlayerName = wordBomb.players[index].name
                  }
                }
            }
            Button("🎉") {
              counter += 1
            }
            .font(.system(size: 45))
            .padding()
            .confettiCannon(counter: $counter)
            .onAppear {
              counter += 2
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
    .onChange(of: wordBomb.yourTurn) { _, _ in
      if wordBomb.yourTurn {
        typedWord = ""
        focusOnTextBox = true
      }
    }
  }
}

#Preview {
  WordBombHostView()
}
