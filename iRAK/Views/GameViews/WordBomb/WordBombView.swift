//
//  WordBombView.swift
//  iRAK
//
//  Created by 90310013 on 5/3/24.
//

import SwiftUI
import Firebase

class WordBombViewModel: ObservableObject {
  var currentUser = try? AuthenticationManager.shared.getAuthenticatedUser()
  private let ref = Database.database().reference().child("gameRoom").child("word")
  private var refHandle: DatabaseHandle?
  @Published var word: String = ""
  
  init() {
    observeWord()
  }
  
  deinit {
    ref.removeObserver(withHandle: refHandle!)
  }
  
  // Function to update the word in the database
  func updateWord(word: String) {
    ref.setValue(word)
  }
  
  // Function to observe changes to the word in the database
  private func observeWord() {
    refHandle = ref.observe(.value) { snapshot in
      if let word = snapshot.value as? String {
        self.word = word
      }
    }
  }
}


struct WordBombView: View {
  @StateObject private var viewModel = WordBombViewModel()
  @State var typedWord: String = ""
  var body: some View {
    VStack {
      TextField("Type the word here", text: $typedWord)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        .onChange(of: typedWord) { newValue in
          viewModel.updateWord(word: newValue)
        }
      
      Text("Word: \(viewModel.word)")
        .padding()
      
    }
  }
}

#Preview {
  WordBombView()
}
