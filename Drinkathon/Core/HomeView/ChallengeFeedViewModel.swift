//
//  ChallengeFeedViewModel.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/9/24.
//

import Foundation

class ChallengeFeedViewModel: ObservableObject {
    @Published var challenges = [Challenge]()
    
    let user: User
    
    init(user: User) {
        self.user = user
        Task { try await fetchChallenges() }
    }
    
    @MainActor
    func fetchChallenges() async throws {
        self.challenges = try await ChallengeService.fetchAllChallenges()
        try await fetchUserDataForChallenges()
        
        print("DEBUG: Fetch challenges called")
    }
    
    @MainActor
    private func fetchUserDataForChallenges() async throws {
        for i in 0 ..< challenges.count {
            let challenge = challenges[i]
            let uid1 = challenge.player1.id
            let uid2 = challenge.player2.id
            let p1User = try await UserService.fetchUser(withUid: uid1)
            let p2User = try await UserService.fetchUser(withUid: uid2)
            
            challenges[i].player1.user = p1User
            challenges[i].player2.user = p2User
        }
    }
    
}
