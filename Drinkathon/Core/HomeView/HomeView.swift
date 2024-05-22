//
//  HomeView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var rootModel: MainTabViewModel
    @ObservedObject var store = StoreProvider.challengeStore

    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                
                // Challenges
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        if (!store.challenges.isEmpty) {
                            
                            // Challenges if not empty
                            ForEach(store.challenges.indices) { index in
                                NavigationLink(destination: ChallengeDetailsView(challenge: $store.challenges[index], currentUsername: rootModel.currentUser?.username ?? "")) {
                                    
                                    // Challenge cell to view details
                                    ChallengeCellView(challenge: $store.challenges[index], currentUsername: rootModel.currentUser?.username ?? "")
                                        .padding(.bottom)
                                }
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
                .navigationTitle("Active Challenges")
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(Color.lighterBlue, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                
                Divider()
                    .overlay(.gray)
                    .padding()
                
                // Add drink
                Button {
                    rootModel.isLoading = true
                    Task {
                        try await rootModel.incrementDrink()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            rootModel.isLoading = false
                        }
                    }
                } label: {
                    Group {
                        if rootModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Log Drink")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                    }
                    .frame(width: 320, height: 44)
                    .background(Color(.green))
                    .cornerRadius(15)
                }
                .padding(.bottom, 50)
            }
            .background(.darkerBlue)
        }
    }
}

#Preview {
    let rootModel = MainTabViewModel()
    let homeView = HomeView().environmentObject(rootModel)
    return homeView
}
