//
//  ChallengeHistoryCell.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI
import Charts

struct ChallengeHistoryCellView: View {
    @State var challenge: Challenge
    
    @State var player1 = Player(id: "Player1", username: "Player1", score: 0)
    @State var player2 = Player(id: "Player2", username: "Player2", score: 0)
    let currentUsername: String
    
    func animateUpdate() {
        withAnimation(.spring(.bouncy(duration: 1), blendDuration: 1)) {
            player1.score = challenge.player1.score
            player2.score = challenge.player2.score
        }
    }
    
    var maxScore: Int {
        let max = player1.score > player2.score ? player1.score : player2.score
        if max == 0 || max == 1 {
            return 3
        } else {
            return max
        }
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    GroupBox {
                        VStack(alignment: .leading) {
                            HStack{
                                Text(challenge.title)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color.white)
                                
                                Spacer()
                                
                                // Display winner if game is done
                                if challenge.status == .finished {
                                    let winner = ChallengeService.getWinnerUsername(challenge: challenge)
                                    
                                    if winner == currentUsername {
                                        Text("Win")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.neonGreen)
                                    } else if winner == "Tie" {
                                        Text("Tie")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.yellow)
                                    } else {
                                        Text("Loss")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.red)
                                    }
                                }
                            }
                            
                            Divider()
                                .overlay(.gray)
                                .padding(.bottom, 4)
                            
                            // Chart
                            Chart([player1, player2]) { player in
                                BarMark(x: .value("Score", player.score < 1 ? 1 : player.score + 1),
                                        y: .value("Player", player.username),
                                        width: .fixed(12)
                                )
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.midnightBlue]), startPoint: .leading, endPoint: .trailing))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .annotation(position: .top, alignment: .leading) {
                                    Text(player.username)
                                        .foregroundColor(Color.white)
                                        .font(.caption)
                                        .padding(.bottom, 2)
                                }
                                .annotation(position: .trailing) {
                                    Text(player.score.formatted())
                                        .foregroundColor(Color.white)
                                        .font(.caption)
                                }
                            }
                            .chartXScale(domain: 0 ... maxScore + 2, range: .plotDimension, type: .linear)
                            .chartXAxis(.hidden)
                            .chartYAxis(.hidden)
                            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            .chartYAxis {
                                AxisMarks(preset: .aligned, position: .leading) { _ in
                                    AxisValueLabel(horizontalSpacing: 8)
                                        .font(.footnote)
                                }
                            }
                            .onAppear {
                                player1.username = challenge.player1.username
                                player2.username = challenge.player2.username
                                animateUpdate()
                            }
                            
                            Divider()
                                .overlay(.gray)
                                .padding(.bottom, 7)
                            
                            // Time left
                            HStack(alignment: .bottom, spacing: 5) {
                                
                                Text("Complete")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.lavender)
                                
                                Spacer()
                            }
                        }
                    }
                    .backgroundStyle(Color.lighterBlue)
                    .cornerRadius(15)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    @State var challenge = DeveloperPreview.shared.challenge1
    let challengeCell = ChallengeHistoryCellView(challenge: challenge, currentUsername: "bgibbons")
    
    return challengeCell
}
