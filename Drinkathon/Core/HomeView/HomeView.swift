//
//  HomeView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @State private var showCreateChallenge = false
    
    private var currentUser: User? {
        return viewModel.currentUser
    }
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Divider()
                
                // Challenges
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(viewModel.challenges) { challenge in
                            ChallengeCellView(challenge: challenge)
                        }
                    }
                }
                
                .sheet(isPresented: $showCreateChallenge, content: {
                    CreateChallengeView()
                })
                .refreshable {
                    print("DEBUG: Refresh called")
                    Task{ try await viewModel.fetchChallenges() }
                }
                .onChange(of: viewModel.currentUser) {
                    Task{ try await viewModel.fetchChallenges() }
                }
                .onAppear {
                    Task{ try await viewModel.fetchChallenges() }
                }
                .navigationTitle("Recent Challenges")
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(Color.lighterBlue, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showCreateChallenge.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color(.blue))
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    }
                }
                
                
                Divider()
                    .overlay(.gray)
                    .padding()
                
                
                // Add drink
                Button {
                    Task { try await viewModel.incrementDrink() }
                } label: {
                    Text("Log Drink")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(width: 320, height: 44)
                        .background(Color(.green))
                        .cornerRadius(8)
                }
                .padding(.bottom, 20)

            }
            .containerRelativeFrame([.horizontal, .vertical])
            .background(.darkerBlue)
        }
    }
}

#Preview {
    let homeView = HomeView()
    return homeView
}
