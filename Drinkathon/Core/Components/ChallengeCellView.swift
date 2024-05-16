//
//  ChallengeCell.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI
import Charts

struct ChallengeCellView: View {
    let challenge: Challenge
    @State private var duration = "---"
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Time formatter
    static var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropLeading
        return formatter
    }()
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 8) {
                CircleProfilePictureView(user: challenge.player1.user, size: .small)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(challenge.title)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.white)
                    
                    GroupBox {
                        VStack(alignment: .leading, spacing: 2) {
                            
                            // Chart
                            Chart([challenge.player1, challenge.player2]) { item in
                                
                                // If score is 0
                                if (item.score == 0) {
                                    BarMark(x: .value("Amount", 1),
                                            y: .value("Name", item.username),
                                            width: .fixed(12)
                                    )
                                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.neonGreen, Color.midnightBlue]), startPoint: .leading, endPoint: .trailing))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .cornerRadius(8)
                                    .annotation(position: .top, alignment: .leading) {
                                        Text(item.username)
                                            .foregroundColor(Color.white)
                                            .font(.caption)
                                            .padding(.bottom, 2)
                                    }
                                    .annotation(position: .trailing) {
                                        Text("0")
                                            .foregroundColor(Color.white)
                                            .font(.caption)
                                    }
                                    
                                    // Regular score > 0
                                } else {
                                    BarMark(x: .value("Amount", item.score),
                                            y: .value("Name", item.username),
                                            width: .fixed(12)
                                    )
                                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.neonGreen, Color.midnightBlue]), startPoint: .leading, endPoint: .trailing))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .cornerRadius(8)
                                    .annotation(position: .top, alignment: .leading) {
                                        Text(item.username)
                                            .foregroundColor(Color.white)
                                            .font(.caption)
                                            .padding(.bottom, 2)
                                    }
                                    .annotation(position: .trailing) {
                                        Text(item.score.formatted())
                                            .foregroundColor(Color.white)
                                            .font(.caption)
                                    }
                                }
                            }
                            .chartXAxis(.hidden)
                            .chartYAxis(.hidden)
                            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            .chartYAxis {
                                AxisMarks(preset: .automatic, position: .leading) { _ in
                                    AxisValueLabel(horizontalSpacing: 8)
                                        .font(.footnote)
                                }
                            }
                            
                            Divider()
                                .overlay(.gray)
                                .padding(.bottom, 7)
                            
                            // Time left
                            HStack(alignment: .bottom, spacing: 5) {
                                
                                // If game is not finished, display time left
                                if challenge.status != .finished {
                                    Text("Time left: ")
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    
                                    Text(duration)
                                        .font(.footnote)
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.red)
                                } else {
                                    Text(duration)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.mint)
                                }
                                
                                Spacer()
                                
                                // Record
                                Text("4-1")
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color.gray)
                            }
                            .onReceive(timer) { _ in
                                var delta = challenge.timeToEnd.timeIntervalSinceNow
                                
                                // Timer done
                                if delta <= 0 {
                                    
                                    // Cancel timer
                                    delta = 0
                                    timer.upstream.connect().cancel()
                                    
                                    // Display winner
                                    if challenge.status == .finished {
                                        if challenge.winner == "tie" {
                                            duration = "Tie"
                                        }
                                        else if challenge.winner != "none" {
                                            let username = ChallengeService.getWinnerUsername(challenge: self.challenge)
                                            duration = "Winner: \(username)"
                                        }
                                    } else {
                                        
                                        // Challenge hasnt been updated on database yet
                                        Task {
                                            try await ChallengeService.finishChallenge(challenge: challenge)
                                        }
                                    }
                                } else {
                                    duration = ChallengeCellView.durationFormatter.string(from: delta) ?? "---"
                                }
                            }
                        }
                    }
                    .backgroundStyle(Color.lighterBlue)
                    .padding(.top, 5)
                    .cornerRadius(15)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    let challengeCell = ChallengeCellView(challenge: DeveloperPreview.shared.challenge1)
    
    return challengeCell
}
