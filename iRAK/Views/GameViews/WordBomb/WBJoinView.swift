//
//  WordBombJoinView.swift
//  iRAK
//
//  Created by 90310013 on 5/7/24.
//

import SwiftUI

struct WordBombJoinView: View {
  @StateObject private var wordBomb = WordBombJoinViewModel()
  @State var gameRoomCode: String = ""
  @State private var isOverlayPresented = true
  @State private var isCodeWrong = false
  // Vars synced with database
  @State var typedWord: String = ""

  var body: some View {
    ZStack {
      Color.backgroundColor
        .ignoresSafeArea()
      VStack {
        Text(wordBomb.gameRoomCode)
          .padding()
        
        TextField("Type the word here", text: $typedWord)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding()
          .onChange(of: typedWord) { newValue in
            wordBomb.updateWord(word: newValue)
          }
        
        Text("Word: \(wordBomb.word)")
          .padding()
      }
      .disabled(isOverlayPresented)
      .blur(radius: isOverlayPresented ? 3 : 0)
      
      if isOverlayPresented {
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
            .autocapitalization(.allCharacters)
            .disableAutocorrection(true)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .onChange(of: gameRoomCode) { _ in
              isCodeWrong = false
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
            self.isOverlayPresented = false
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
