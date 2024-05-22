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
    @State private var duration = "---"
    @Environment(\.dismiss) var dismiss
    @State var presentConfirm = false
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
        NavigationStack {
            VStack {
                GroupBox {
                    VStack{
                        Text(challenge.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.white)
                            .padding(.bottom, 7)
                        
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
                            print("ChallengeCell onAppear called")
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
                    }
                    
                    Divider()
                        .overlay(.gray)
                        .padding(.bottom, 7)
                    
                    // Time left
                    HStack(alignment: .bottom, spacing: 5) {
                        
                        // If game is not finished, display time left
                        if challenge.status != .finished {
                            Text("Time remaining: ")
                                .font(.footnote)
                                .foregroundStyle(.white)

                            Text(duration)
                                .font(.footnote)
                                .fontWeight(.medium)
                                .foregroundStyle(.red)
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
                                timer.upstream.connect().cancel()
                                dismiss()
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
                    .onDisappear {
                        timer.upstream.connect().cancel()
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
                            duration = DateTimeString.durationFormatter.string(from: delta) ?? "---"
                        }
                    }
                }
                .backgroundStyle(.lighterBlue)
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
                        presentConfirm = true
                        
                    } label: {
                        Text("Delete Challenge")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(width: 320, height: 44)
                            .background(Color(.red))
                            .cornerRadius(8)
                    }
                    
                    // Confirm delete
                    .confirmationDialog("Are you sure?", isPresented: $presentConfirm) {
                        Button("Delete Challenge", role: .destructive) {
                            dismiss()
                            Task {
                                try await ChallengeService.deleteChallenge(challenge: challenge)
                            }
                            
                            presentConfirm = false
                        }
                    }
                    .dialogIcon(Image(systemName: "trash.circle.fill"))
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
