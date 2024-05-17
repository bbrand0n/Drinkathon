//
//  ChallengeDetailsView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/17/24.
//

import SwiftUI
import Charts

struct ChallengeDetailsView: View {
    @EnvironmentObject var rootModel: MainTabViewModel
    @Binding var challenge: Challenge
    let currentUsername: String
    @Environment(\.dismiss) var dismiss
    
    var history: [(player: String, data: [Drink])] {
        return [(player: "Player1", data: challenge.player1.drinks ?? []),
                (player: "Player2", data: challenge.player2.drinks ?? [])]
    }
    
    var maxScore : Int {
        return max(challenge.player1.score, challenge.player2.score)
    }
    
    func graphLineAreaGradient(color: Color) -> LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [
            color.opacity(0.5),
            color.opacity(0.3),
            color.opacity(0.2)]), startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                GroupBox {
                    VStack{
                        Text(challenge.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.white)
                        
                        Divider()
                            .overlay(.gray)
                            .padding(.bottom, 4)
                        
                        Chart(history, id: \.player)  { series in
                            ForEach(series.data) { item in
                                LineMark(
                                    x: .value("Hour", item.time, unit: .minute),
                                    y: .value("Drinks", item.drink)
                                )
                                .symbol(.circle)
                                .interpolationMethod(.linear)
                                
                                AreaMark (
                                    x: .value("Hour", item.time, unit: .minute),
                                    yStart: .value("Low", 0),
                                    yEnd: .value("Low", item.drink)
                                )
                                .foregroundStyle(by: .value("Player", series.player))
                                .interpolationMethod(.linear)
                            }
                            .foregroundStyle(by: .value("Player", series.player))
                            .symbol(by: .value("Player", series.player))
                            
                        }
                        .chartForegroundStyleScale([
                            "Player1": graphLineAreaGradient(color: .neonGreen),
                            "Player2": graphLineAreaGradient(color: .neonPink)
                        ])
                        .chartLegend(position: .overlay, alignment: .leading, spacing: 24){
                            VStack(alignment: .leading) {
                                // Player 1
                                HStack {
                                    Circle()
                                        .fill(.neonGreen)
                                        .frame(width: 8, height: 8)
                                    Text(challenge.player1.username)
                                        .foregroundStyle(.white)
                                        .font(.caption)
                                }
                                
                                HStack {
                                    // Player 2
                                    Circle()
                                        .fill(.neonPink)
                                        .frame(width: 8, height: 8)
                                    Text(challenge.player2.username)
                                        .foregroundStyle(.white)
                                        .font(.caption)
                                }
                                
                                Spacer()
                            }
                        }
                        .background(.lighterBlue)
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .minute, count: 30)) { _ in
                                AxisValueLabel(format:
                                        .dateTime.hour(.defaultDigits(amPM: .omitted))
                                        .minute(.twoDigits))
                                .foregroundStyle(.gray)
                            }
                        }
                        .chartYAxis {
                            AxisMarks { _ in
                                AxisValueLabel().foregroundStyle(.white)
                            }
                        }
                        .chartYScale(domain: 0 ... maxScore + 4)
                        .frame(height: 300)
                    }
                    .overlay {
                        if (challenge.player1.score == 0 && challenge.player2.score == 0)
                        {
                            Text("Start drinking!")
                                .font(.title)
                                .foregroundStyle(.gray)
                        }
                    }
                }
                .backgroundStyle(Color.lighterBlue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
                
                Spacer()
                
                // Buttons
                VStack (spacing: 20){
                    
                    // Add drink
                    Button {
                        Task {
                            try await rootModel.incrementDrink()
                        }
                    } label: {
                        Text("Log Drink")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(width: 320, height: 44)
                            .background(Color(.green))
                            .cornerRadius(8)
                    }
                    
                    // Delete challenge
                    Button {
                        Task {
                            try await ChallengeService.deleteChallenge(challenge: challenge)
                            dismiss()
                        }
                    } label: {
                        Text("Delete Challenge")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(width: 320, height: 44)
                            .background(Color(.red))
                            .cornerRadius(8)
                    }
                    .padding(.bottom, 50)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.darkerBlue)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.lighterBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}


#Preview {
    let tabView = MainTabView()
    tabView.viewModel.store.challenges = [DeveloperPreview.shared.challenge2]
    let view = ChallengeDetailsView(challenge: tabView.$viewModel.store.challenges[0], currentUsername: "blah")
    return view
}
