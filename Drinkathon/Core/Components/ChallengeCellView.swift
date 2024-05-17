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
    let currentUsername: String
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
                                    
                                    
                                } else {
                                    // Regular score > 0
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
                                .disabled(challenge.status != .finished)
                                
                            }
                            .onReceive(timer) { _ in
                                var delta = challenge.timeToEnd.timeIntervalSinceNow
                                
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
                                    duration = ChallengeCellView.durationFormatter.string(from: delta) ?? "---"
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
    let challengeCell = ChallengeCellView(challenge: DeveloperPreview.shared.challenge1, currentUsername: "bgibbons")
    
    return challengeCell
}
