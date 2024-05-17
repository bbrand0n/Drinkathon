//
//  HomeView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var rootModel: MainTabViewModel
    @State private var showCreateChallenge = false

    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                
                // Challenges
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        if (!rootModel.challenges.isEmpty) {
                            
                            // Challenges if not empty
                            ForEach(rootModel.challenges) { challenge in
                                ChallengeCellView(challenge: challenge, currentUsername: rootModel.currentUser?.username ?? "")
                                    .padding(.bottom)
                            }
                        } else {
                            
                            // No Challenges to display
                            Text("No challenges")
                                .font(.title3)
                                .foregroundStyle(.gray)
                                .padding(.top, 70)
                                .opacity(0.8)
                            Text("Go to \"+\" tab to compete with friends!")
                                .font(.title3)
                                .foregroundStyle(.gray)
                                .padding(.top)
                                .opacity(0.8)
                        }
                    }
                }
                .padding(.top)
                .refreshable {
                    print("HomeView: Refresh called")
                    Task{
                        try await rootModel.fetchChallenges()
                    }
                }
                .navigationTitle("Recent Challenges")
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(Color.lighterBlue, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                
                Divider()
                    .overlay(.gray)
                    .padding()
                
                // Add drink
                Button {
                    Task { try await rootModel.incrementDrink() }
                } label: {
                    Text("Log Drink")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(width: 320, height: 44)
                        .background(Color(.green))
                        .cornerRadius(8)
                }
                .padding(.bottom, 50)
            }
            .background(.darkerBlue)
        }
    }
}

#Preview {
    let rootModel = MainTabViewModel()
    let homeView = HomeView(rootModel: rootModel)
    return homeView
}
