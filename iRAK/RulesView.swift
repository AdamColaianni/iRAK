//
//  RulesView.swift
//  iRAK
//
//  Created by 64016641 on 5/20/24.
//

import SwiftUI

struct RulesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text("WordBomb Rules")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.9, green: 0.2, blue: 0.5))
                    .padding(.top, 20)
                
                // Subtitle with Bomb Icon
                HStack {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.orange)
                    Text("Beat the clock!")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                
                // Detailed Rules
                VStack(alignment: .leading, spacing: 10) {
                    RuleItem(number: "1.", text: "Objective: Each player must fill in a word that contains a given segment before the bomb explodes.")
                    RuleItem(number: "2.", text: "Example: If shown the segment “ING”, a player might fill in the word “THINKING”.")
                    RuleItem(number: "3.", text: "Timer: Players are on a timer. If the timer runs out, the bomb explodes, and the player is eliminated.")
                    RuleItem(number: "4.", text: "Lives: Each player starts with 2 lives.")
                    RuleItem(number: "5.", text: "Failure: If two players in a row fail to provide a word, a new segment is given.")
                    RuleItem(number: "6.", text: "Winning: The last player remaining wins the game.")
                }
                .padding(.bottom, 10)
                
                // Game Image
                Image("gameImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.bottom, 10)
                
                // Do's and Don'ts Images
                HStack(spacing: 15) {
                    Image("doImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    
                    Image("dontImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.bottom, 10)
                
                // Game Tip
                Text("Tip: During the game, try and think of a word for the player in front of you. You never know, they may get it wrong and better be safe than sorry!")
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.bottom, 10)
                
                // Game Tips with Bullet Points
                VStack(alignment: .leading, spacing: 10) {
                    Text("Game Tips:")
                        .font(.headline)
                        .foregroundColor(.orange)
                        .padding(.bottom, 5)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(alignment: .top) {
                            Text("•")
                            Text("Think fast and act quickly!")
                        }
                        HStack(alignment: .top) {
                            Text("•")
                            Text("Collaborate with other players.")
                        }
                        HStack(alignment: .top) {
                            Text("•")
                            Text("Stay calm and focused.")
                        }
                    }
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding(.bottom, 10)
                
                Spacer()
            }
            .padding()
        }
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.3)
        )
    }
}

// RuleItem View
struct RuleItem: View {
    var number: String
    var text: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(number)
                .font(.headline)
                .foregroundColor(.purple)
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView()
    }
}







