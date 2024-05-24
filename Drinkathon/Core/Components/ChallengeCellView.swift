//
//  ChallengeCell.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI
import Charts

struct ChallengeCellView: View {
    @Binding var challenge: Challenge
    
    @State var player1 = Player(id: "Player1", username: "Player1", score: 0)
    @State var player2 = Player(id: "Player2", username: "Player2", score: 0)
    @State private var duration = "---"
    @State var timeToEnd = Date.now
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
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
                                timeToEnd = challenge.timeToEnd
                                player1.username = challenge.player1.username
                                player2.username = challenge.player2.username
                                animateUpdate()
                            }
                            .onChange(of: challenge.player1.score) {
                                animateUpdate()
                            }
                            .onChange(of: challenge.player2.score) {
                                animateUpdate()
                            }
                            .onChange(of: challenge.timeToEnd) {
                                timeToEnd = challenge.timeToEnd
                            }
                            
                            Divider()
                                .overlay(.gray)
                                .padding(.bottom, 7)
                            
                            // Time left
                            HStack(alignment: .bottom, spacing: 5) {
                                
                                // If game is not finished, display time left
                                if challenge.status != .finished {
                                    Text(duration)
                                        .font(.footnote)
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.red)
                                } else {
                                    Text("Complete")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.lavender)
                                }
                                
                                Spacer()
                                
                                if challenge.status == .finished {
                                    Menu {
                                        // Delete button
                                        Button(role: .destructive) {
                                            Task {
                                                try await ChallengeService.deleteChallenge(challenge: challenge)
                                            }
                                        } label: {
                                            Label("Delete Challenge", systemImage: "trash")
                                        }
                                    } label: {
                                        Image(systemName: "ellipsis.circle")
                                            .clipShape(Circle())
                                    }
                                } else {
                                    // Details
                                    Image(systemName: "greaterthan.circle")
                                        .clipShape(Circle())
                                }
                            }
                            .onDisappear {
                                timer.upstream.connect().cancel()
                            }
                            .onReceive(timer) { _ in
                                var delta = timeToEnd.timeIntervalSinceNow
                                
                                // Timer done
                                if delta <= 0 {
                                    
                                    // Cancel timer
                                    delta = 0
                                    timer.upstream.connect().cancel()
                                    
                                    // If not updated yet, update
                                    if (challenge.status != .finished) {
                                        Task { try await ChallengeService.finishChallenge(challenge:challenge)}
                                    }
                                    
                                } else {
                                    duration = DateTimeString.durationFormatter.string(from: delta) ?? "---"
                                }
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
    let challengeCell = ChallengeCellView(challenge: $challenge, currentUsername: "bgibbons")
    
    return challengeCell
}
