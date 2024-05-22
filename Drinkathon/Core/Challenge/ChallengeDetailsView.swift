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
    @State var presentConfirm = false
    @State private var duration = "---"
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func graphLineAreaGradient(color: Color) -> LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [
            color.opacity(0.5),
            color.opacity(0.3),
            color.opacity(0.2)]), startPoint: .top, endPoint: .bottom)
    }
    
    func gradient(_ color1: Color, _ color2: Color) -> RadialGradient {
//        return LinearGradient(gradient: Gradient(colors: [
//            color1, color1.opacity(0.8),color2]),
//                              startPoint: .top, endPoint: .bottom)
        return RadialGradient(colors: [color1, color2], center: .center, startRadius: 1, endRadius: 1000)
    }
    
    // Time formatter
    static var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropLeading
        return formatter
    }()
    
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
                        .frame(height: 120)
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
                            Task {
                                try await ChallengeService.deleteChallenge(challenge: challenge)
                            }
                            dismiss()
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
