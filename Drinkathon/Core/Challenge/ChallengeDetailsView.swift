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
    
    @State var player1 = Player(id: "Player1", username: "Player1", score: 0)
    @State var player2 = Player(id: "Player2", username: "Player2", score: 0)
    @State var duration = "---"
    @State var progress = 0.97
    @Environment(\.dismiss) var dismiss
    @State var deleteConfirm = false
    @State var endConfirm = false
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
    
    var totalDuration: TimeInterval {
        return challenge.timeToEnd.timeIntervalSince(challenge.timeSent.dateValue())
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                GroupBox {
                    VStack{
                        HStack(alignment: .center) {
                            Text(challenge.title)
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundStyle(Color.white)
                                .padding(.bottom, 7)
                        }
                        
                        Divider()
                            .overlay(.gray)
                            .padding(.bottom, 15)
                        
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
                    }
                    
                    Divider()
                        .overlay(.gray)
                        .padding(.bottom, 7)
                    
                    VStack {
                        // Time left
                        HStack(alignment: .center, spacing: 5) {
                            
                            // If game is not finished, display time left
                            if challenge.status != .finished {
                                Text("Started: ")
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                                
                                Text(challenge.timeSent.dateValue()
                                    .formatted(date: .omitted, time: .shortened))
                                .font(.footnote)
                                .fontWeight(.medium)
                                .foregroundStyle(.gray)
                            } else {
                                Text("Complete")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.lavender)
                            }
                            
                            Spacer()
                            
                            Menu {
                                // Remove drink button
                                Button(role: .cancel) {
                                    Task {
                                        try await rootModel.decrementDrink()
                                    }
                                } label: {
                                    Label("Remove Last Drink", systemImage: "wineglass")
                                }
                                // Delete button
                                Button(role: .destructive) {
                                    Task {
                                        deleteConfirm = true
                                    }
                                } label: {
                                    Label("Delete Challenge", systemImage: "trash")
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .clipShape(Circle())
                            }
                        }
                    }
                    
                    .padding(.top, 2)
                    .onDisappear {
                        timer.upstream.connect().cancel()
                    }
                    .onReceive(timer) { _ in
                        var delta = timeToEnd.timeIntervalSinceNow
                        let temp = (delta / totalDuration)
                        progress = temp > 0.97 ? 0.97 : temp
                        
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
                .backgroundStyle(.lighterBlue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
                
                VStack {
                    HStack(alignment: .center, spacing: 20) {
                        
                        // Extend time
                        Button {
                            Task {
                                try await rootModel.incrementTime(cid: challenge.id, currentTimeToEnd: challenge.timeToEnd)
                            }
                        } label: {
                            VStack {
                                Image(systemName: "clock.badge.checkmark")
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.white)
                                Text("+1hr")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(.green)
                                
                            }
                            .frame(width: 70, height: 44)
                            .padding(.vertical, 15)
                            .background(
                                RadialGradient(colors: [.lighterBlue, .lighterBlue.opacity(0.2)], center: .center, startRadius: 10, endRadius: 60)
                            )
                            .clipShape(Circle())
                            
                        }
                        
                        CountdownTimer(progress: $progress, duration: duration).opacity(0.9)
                        
                        // Remove time
                        Button {
                            Task {
                                try await rootModel.decrementTime(cid: challenge.id, currentTimeToEnd: challenge.timeToEnd)
                            }
                        } label: {
                            VStack {
                                Image(systemName: "clock.badge.xmark")
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.white)
                                Text("-1hr")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.red)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal, 5)
                                
                            }
                            .frame(width: 70, height: 44)
                            .padding(.vertical, 15)
                            .background(
                                RadialGradient(colors: [.lighterBlue, .lighterBlue.opacity(0.2)], center: .center, startRadius: 10, endRadius: 60)
                            )
                            .clipShape(Circle())
                        }
                    }
                    
                }
                .padding(.vertical, 45)
                .padding()
                
                Spacer()
                
                // Buttons
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(height: 180)
                        .foregroundStyle(LinearGradient(
                            colors: [.lighterBlue.opacity(1), .lighterBlue.opacity(0.50), .lighterBlue.opacity(0)],
                            startPoint: .top,
                            endPoint: .bottom))
                    
                    VStack (spacing: 20) {
                        
                        // Add drink
                        Button {
                            Task {
                                try await rootModel.incrementDrink()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "wineglass")
                                    .foregroundColor(.black)
                                
                                Text("Log Drink")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                            }
                            .frame(width: 320, height: 44)
                            .background(Color(.green))
                            .cornerRadius(15)
                            
                        }
                        
                        // Delete challenge
                        Button {
                            endConfirm = true
                            
                        } label: {
                            HStack {
                                Image(systemName: "flag.2.crossed")
                                    .foregroundColor(.black)
                                
                                Text("End Challenge")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                
                            }
                            .frame(width: 320, height: 44)
                            .background(Color(.red).opacity(0.85))
                            .cornerRadius(15)
                            
                        }
                        
                        // Confirm delete
                        .confirmationDialog("Are you sure?", isPresented: $deleteConfirm) {
                            Button("Delete Challenge", role: .destructive) {
                                dismiss()
                                Task {
                                    try await ChallengeService.deleteChallenge(challenge: challenge)
                                }
                                
                                deleteConfirm = false
                            }
                        }
                        .dialogIcon(Image(systemName: "trash.circle.fill"))
                        
                        // Confirm delete
                        .confirmationDialog("End challenge?", isPresented: $endConfirm) {
                            Button("End Challenge", role: .destructive) {
                                dismiss()
                                Task {
                                    try await rootModel.endChallenge(cid: challenge.id)
                                }
                                
                                endConfirm = false
                            }
                        }
                        .dialogIcon(Image(systemName: "x.circle"))
                    }
                    .padding()
                    .padding(.bottom, 20)
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
