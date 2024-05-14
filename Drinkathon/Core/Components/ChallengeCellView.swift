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
    
    //    var displayString: String {
    //        if challenge.status != .finished {
    //            return duration
    //        } else {
    //            if challenge.winner == "tie" {
    //                return "TIE!"
    //            }
    //            else if challenge.winner != "none" {
    //                Task {
    //                    if let winner = challenge.winner {
    //                        let username = try await UserService.fetchUser(withUid: winner)
    //                        return username?.username
    //                }
    //            }
    //        }
    //    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 8) {
                CircleProfilePictureView(user: nil, size: .small)
                
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
                                    .foregroundStyle(.red)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
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
                                    .foregroundStyle(.blue)
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
                            .padding(.bottom)
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
                                .padding(.bottom, 5)
                            
                            // Time left
                            HStack(alignment: .bottom, spacing: 5) {
                                
                                if challenge.status != .finished {
                                    Text("Time left: ")
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                                
                                
                                Text(duration)
                                    .font(.footnote)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.red)
                                
                                Spacer()
                                
                                Text("4-1")
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color.gray)
                            }
                            .onReceive(timer) { _ in
                                var delta = challenge.timeToEnd.timeIntervalSinceNow
                                if delta <= 0 {
                                    delta = 0
                                    timer.upstream.connect().cancel()
                                    
                                    Task {
                                        try await ChallengeService.cleanChallenges()
                                        
                                        if challenge.status != .finished {
                                            delta = 0
                                        } else {
                                            if challenge.winner == "tie" {
                                                duration = "TIE!"
                                            }
                                            else if challenge.winner != "none" {
                                                if let winner = challenge.winner {
                                                    let username = try await UserService.fetchUser(withUid: winner)
                                                    duration = "Winner: \(username?.username ?? "")"
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                duration = ChallengeCellView.durationFormatter.string(from: delta) ?? "---"
                            }
                        }
                    }
                    .backgroundStyle(Color.lighterBlue)
                    .padding(.top, 5)
                    .cornerRadius(15)
                }
            }
            .padding(.horizontal)
            Divider()
                .overlay(.gray)
                .padding()
        }
        
    }
}

#Preview {
    let challengeCell = ChallengeCellView(challenge: DeveloperPreview.shared.challenge)
    
    return challengeCell
}
