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
  @State private var counter: Int = 0
  @State private var winningPlayerName: String = ""
  @FocusState var focusOnCodeTextBox: Bool
  @FocusState var focusOnMessageTextBox: Bool
  // Vars synced with database
  @State var typedWord: String = ""

  var body: some View {
    ZStack {
      Color.backgroundColor
        .ignoresSafeArea()
      VStack {
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
                .multilineTextAlignment(.center)              }
              .padding()
              .background(
                RoundedRectangle(cornerRadius: 10)
                  .stroke(wordBomb.players[index].uid == wordBomb.cplayer ? Color.red : Color.primary, lineWidth: 2)
              )
            }
          }
          .padding()
        }
        
        Text("Letters: \(wordBomb.letters)")
          .padding()
        
        if wordBomb.yourTurn {
          Text("IT'S YOUR TURN!!!")
        }
        
        VStack {
          Text(wordBomb.gameRoomCode)
            .font(.system(size: 25))
            .padding()
          
          Text("Word: \(wordBomb.word.trimmingCharacters(in: CharacterSet(charactersIn: "~")))")
            .padding()
        }

        CustomTextField(placeholder: "Type the word here", text: $typedWord) {
          wordBomb.submit()
        }
        .focused($focusOnMessageTextBox)
        .autocorrectionDisabled()
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        .onChange(of: typedWord) { _, newValue in
          wordBomb.updateWord(word: newValue)
        }
        .disabled(!wordBomb.yourTurn)
        .frame(maxHeight: 44)
      }
      .disabled(isJoinPresented || wordBomb.hasRoomEnded)
      .blur(radius: (isJoinPresented || wordBomb.hasRoomEnded) ? 3 : 0)
      .disabled(wordBomb.gameFinished)
      .blur(radius: (wordBomb.gameFinished) ? 3 : 0)
      
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
      
      if !wordBomb.gameFinished && wordBomb.hasRoomEnded {
        ZStack {
          Color.black.opacity(0.2)
            .edgesIgnoringSafeArea(.all)
          VStack {
            Text("Game has ended unexpectedly")
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
    .onChange(of: wordBomb.yourTurn) { _, _ in
      if wordBomb.yourTurn {
        typedWord = ""
        focusOnMessageTextBox = true
      }
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
