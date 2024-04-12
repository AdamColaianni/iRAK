//
//  HumanBenchmarkView.swift
//  iRAK
//
//  Created by 64016641 on 4/9/24.
//

import SwiftUI

struct HumanBenchmarkView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Game UI
                ZStack {
                    Button(action: {
                        // Action when game view is tapped
                        // Navigate to next screen or perform other action
                    }) {
                        ZStack {
                            Color(red: 0.9, green: 0.3, blue: 0.3) // Red background inside GameView
                                .edgesIgnoringSafeArea(.all)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            VStack {
                                Text("Wait for green...")
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .padding(.top, 20)
                                
                                Image(systemName: "bolt.fill") // Lightning bolt SF symbol
                                    .font(.system(size: 100))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .padding()
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Spacer()
                    }
                }
                .padding()
                .background(Color(red: 0.95, green: 0.95, blue: 0.95)) // Light gray background outside GameView
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .navigationBarHidden(true)
                
                // Leaderboard
                VStack(alignment: .leading) {
                    Text("Leaderboard")
                        .font(.title)
                        .padding(.horizontal)
                    
                    List {
                        ForEach(1...10, id: \.self) { index in
                            // Replace the dummy data with actual leaderboard data
                            Text("\(index). Player \(index): \(Double.random(in: 0.1...1.0), specifier: "%.2f")s")
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(height: 200)
                .padding()
                .background(Color(red: 0.95, green: 0.95, blue: 0.95)) // Different gray background
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding()
        }
        .accentColor(.black) // Set accent color for navigation items
    }
}

struct HumanBenchmarkView_Previews: PreviewProvider {
    static var previews: some View {
        HumanBenchmarkView()
    }
}



