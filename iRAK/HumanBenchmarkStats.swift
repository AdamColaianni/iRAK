//
//  HumanBenchmarkStats.swift
//  iRAK
//
//  Created by 64016641 on 4/15/24.
//

import SwiftUI

struct StatisticsView: View {
    let constantStats: [(title: String, value: String)]
    let gameStats: [String]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.width * 0.03) {
                Text("Human Benchmark")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, geometry.size.width * 0.05)
                
                Text("Statistics")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                VStack(spacing: geometry.size.width * 0.03) {
                    HStack(spacing: geometry.size.width * 0.03) {
                        SquareButton(title: constantStats[0].title, value: constantStats[0].value)
                            .frame(width: (geometry.size.width - 3 * (geometry.size.width * 0.03)) / 2, height: (geometry.size.width - 3 * (geometry.size.width * 0.03)) / 2)
                        SquareButton(title: constantStats[1].title, value: constantStats[1].value)
                            .frame(width: (geometry.size.width - 3 * (geometry.size.width * 0.03)) / 2, height: (geometry.size.width - 3 * (geometry.size.width * 0.03)) / 2)
                    }
                    
                    HStack(spacing: geometry.size.width * 0.03) {
                        SquareButton(title: constantStats[2].title, value: constantStats[2].value)
                            .frame(width: (geometry.size.width - 3 * (geometry.size.width * 0.03)) / 2, height: (geometry.size.width - 3 * (geometry.size.width * 0.03)) / 2)
                        SquareButton(title: constantStats[3].title, value: constantStats[3].value)
                            .frame(width: (geometry.size.width - 3 * (geometry.size.width * 0.03)) / 2, height: (geometry.size.width - 3 * (geometry.size.width * 0.03)) / 2)
                    }
                }
                
                Spacer()
                
                ForEach(gameStats, id: \.self) { stat in
                    BulletStatView(text: stat)
                        .frame(maxWidth: .infinity) // Adjusted to fill the screen width
                }
                
                Spacer()
            }
            .padding(geometry.size.width * 0.05)
            .background(
                RoundedRectangle(cornerRadius: geometry.size.width * 0.04)
                    .fill(Color.gray.opacity(0.2))
                    .shadow(color: .black, radius: 5, x: 0, y: 2)
            )
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct SquareButton: View {
    let title: String
    let value: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(Color.gray.opacity(0.5))
            .overlay(
                VStack(spacing: 10) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(value)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding()
            )
            .shadow(color: .black, radius: 3, x: 0, y: 1)
    }
}

struct BulletStatView: View {
    let text: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(Color.gray.opacity(0.5))
            .overlay(
                Text(text)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding()
            )
            .frame(maxWidth: .infinity) // Adjusted to fill the screen width
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
            .shadow(color: .black, radius: 1, x: 0, y: 1)
            .padding(.horizontal)
    }
}

struct HumanBenchmarkStatsView: View {
    let constantStatistics: [(title: String, value: String)] = [
        ("Time Played", "10h 25m"),
        ("Games Played", "50"),
        ("Slowest Time", "1m 30s"),
        ("Fastest Time", "20s")
    ]
    
    let gameStatistics: [String] = [
        "Average Time: 50s",
        "Score: 500",
        "Accuracy: 90%",
        "Levels Completed: 10"
    ]
    
    var body: some View {
        StatisticsView(constantStats: constantStatistics, gameStats: gameStatistics)
            .font(.custom("PressStart2P-Regular", size: 16))
    }
}

struct HumanBenchmarkStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HumanBenchmarkStatsView()
    }
}



























