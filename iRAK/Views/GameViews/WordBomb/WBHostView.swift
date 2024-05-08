//
//  WordBombView.swift
//  iRAK
//
//  Created by 90310013 on 5/3/24.
//

import SwiftUI

struct WordBombHostView: View {
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
    .onDisappear {
      viewModel.cleanUp()
    }
  }
}

#Preview {
  WordBombHostView()
}
