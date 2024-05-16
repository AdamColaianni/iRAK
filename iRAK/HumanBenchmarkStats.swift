//
//  HumanBenchmarkStats.swift
//  iRAK
//
//  Created by 64016641 on 4/15/24.
//
import SwiftUI

extension Color {
    static let midgroundColor = Color(red: 0.5, green: 0.5, blue: 0.5) // Adjust the RGB values as needed
}

struct PrimaryButtonStyle: ButtonStyle {
    @State var image: String
    @State var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.gray, color]), startPoint: .top, endPoint: .bottom).mask(Image(systemName: image)
                .resizable()
                .scaledToFit()
                .padding(5))
            configuration.label
                .font(.system(size: 20, weight: .bold))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(configuration.isPressed ? Color.midgroundColor.opacity(0.5) : Color.midgroundColor)
        .foregroundColor(.primary)
        .clipShape(Rectangle())
        .cornerRadius(20)
        .shadow(radius: 3)
        .padding(5)
    }
}

struct BulletStatView: View {
    let name: String
    let value: String
    
    var body: some View {
        HStack {
            Text(name)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineLimit(1) // Constrain to one line
                .padding(.leading, 16)
                .frame(width: 140, alignment: .leading)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineLimit(1) // Constrain to one line
                .padding(.trailing, 16)
                .frame(width: 140, alignment: .trailing)
        }
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.gray.opacity(0.5))
                .shadow(color: .black, radius: 1, x: 0, y: 1)
        )
        .padding(.horizontal)
    }
}

struct StatisticsView: View {
    let constantStats: [(title: String, value: String)]
    let gameStatNames: [String]
    let gameStatValues: [String]
    
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
                        Button(action: {}) {
                            VStack {
                                Text(constantStats[0].title)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.trailing) // Align text right
                                Text("\(constantStats[0].value)...")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.trailing) // Align text right
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle(image: "gear", color: .blue))
                        .frame(width: (geometry.size.width - 3 * (geometry.size.width * 0.03)) / 2, height: (geometry.size.width - 3 * (geometry.size.width * 0.03)) / 2)
                        
                        Button(action: {}) {
                            VStack {
                                Text(constantStats[1].title)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.trailing) // Align text right
                                Text("\(constantStats[1].value)...")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.trailing) // Align text right
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle(image: "gear", color: .blue))
                        .frame(width: (geometry.size.width - 3 * (geometry.size.width * 0.03)) / 2, height: (geometry.size.width - 3 * (geometry.size.width * 0.03)) / 2)
                    }
                    
                    HStack(spacing: geometry.size.width * 0.03) {
                        Button(action: {}) {
                            VStack {
                                Text(constantStats[2].title)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.trailing) // Align text right
                                Text("\(constantStats[2].value)...")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.trailing) // Align text right
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle(image: "gear", color: .blue))
                        .frame(width: (geometry.size.width - 3 * (geometry.size.width * 0.03)) / 2, height: (geometry.size.width - 3 * (geometry.size.width * 0.03)) / 2)
                        
                        Button(action: {}) {
                            VStack {
                                Text(constantStats[3].title)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.trailing) // Align text right
                                Text("\(constantStats[3].value)...")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.trailing) // Align text right
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle(image: "gearshape.fill", color: .blue))
                        .frame(width: (geometry.size.width - 3 * (geometry.size.width * 0.03)) / 2, height: (geometry.size.width - 3 * (geometry.size.width * 0.03)) / 2)
                    }
                }
                
                Spacer()
                
                ForEach(Array(zip(gameStatNames, gameStatValues)), id: \.0) { name, value in
                    BulletStatView(name: name, value: value)
                        .frame(maxWidth: .infinity) // Adjusted to fill the screen width
                }
                
                Spacer()
            }
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



struct HumanBenchmarkStatsView: View {
    let constantStatistics: [(title: String, value: String)] = [
        ("Time Played", "10h 25m"),
        ("Games Played", "50"),
        ("Slowest Time", "1m 30s"),
        ("Fastest Time", "20s")
    ]
    
    let gameStatNames: [String] = [
        "Average Time",
        "Score",
        "Accuracy",
        "Levels Completed"
    ]
    
    let gameStatValues: [String] = [
        "50s",
        "500",
        "90%",
        "10"
    ]
    
    var body: some View {
        StatisticsView(constantStats: constantStatistics, gameStatNames: gameStatNames, gameStatValues: gameStatValues)
            .font(.custom("PressStart2P-Regular", size: 16))
    }
}

struct HumanBenchmarkStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HumanBenchmarkStatsView()
    }
}




































