//
//  HumanBenchmarkView.swift
//  iRAK
//
//  Created by 64016641 on 4/9/24.
//

import SwiftUI

struct HumanBenchmarkView: View {
  var body: some View {
    ZStack {
      Color("BackgroundColor")
        .ignoresSafeArea()
      VStack {
        Button(action: {
          // Action when game view is tapped
        }) {
          VStack {
            Text("Wait for green...")
              .font(.title)
            Image(systemName: "bolt.fill")
              .font(.system(size: 100))
          }
          .padding()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(Color(red: 0.9, green: 0.3, blue: 0.3))
          .foregroundColor(.white)
          .cornerRadius(10)
          .shadow(radius: 3)
          .padding()
        }
        
        // Leaderboard
        VStack {
          Text("Leaderboard")
            .font(.title)
          ScrollView {
            ForEach(1...10, id: \.self) { index in
              // Replace the dummy data with actual leaderboard data
              Text("\(index). Player \(index): \(Double.random(in: 0.1...1.0), specifier: "%.2f")s")
            }
          }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .background(Color("ForegroundColor"))
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding()
      }
    }
  }
}

struct HumanBenchmarkView_Previews: PreviewProvider {
  static var previews: some View {
    HumanBenchmarkView()
  }
}



