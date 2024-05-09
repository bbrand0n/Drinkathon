//
//  HomeView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()

    private var currentUser: User? {
        return viewModel.currentUser
    }
    
    var body: some View {
        NavigationStack {
            
            Divider()
            
            // Challenges
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.challenges) { challenge in
                        ChallengeCellView(challenge: challenge)
                    }
                }
            }
            .refreshable {
                Task{ try await viewModel.fetchChallenges() }
            }
            .onChange(of: viewModel.currentUser) {
                Task{ try await viewModel.fetchChallenges() }
            }
            .navigationTitle("Recent Challenges")
            .navigationBarTitleDisplayMode(.inline)
            
            Divider()
            
            // Add drink
            Button {
                Task { try await viewModel.incrementDrink() }
            } label: {
                Text("Log Drink")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(width: 320, height: 44)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
            
            Divider()
        }
        
    }
}

#Preview {
    let homeView = HomeView()
    return homeView
}
