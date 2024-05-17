//
//  UserHistoryViewModel.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/15/24.
//

import Foundation
import Combine
import Firebase

class UserHistoryViewModel : ObservableObject {
    @Published var challengesHistory = [Challenge]()
    @Published var currentUser: User
    
    init(user: User) {
        self.currentUser = user
        Task { try await fetchUserHistory() }
    }
    
    @MainActor
    func fetchUserHistory() async throws {
        print("UserHistoryViewModel: fetching history")
        
        challengesHistory = try await ChallengeService.fetchUserHistory(uid: currentUser.id)
//        try await fetchUserDataForChallenges()
    }
    
    @MainActor
    private func fetchUserDataForChallenges() async throws {
        do {
            for i in 0 ..< self.challengesHistory.count {
                let challenge = self.challengesHistory[i]
                let uid1 = challenge.player1.id
                let uid2 = challenge.player2.id
                let p1User = try await UserService.fetchUser(withUid: uid1)
                let p2User = try await UserService.fetchUser(withUid: uid2)

                self.challengesHistory[i].player1.user = p1User
                self.challengesHistory[i].player2.user = p2User
            }
        } catch {
            print("Out of bounds UserHistory: \(error)")
        }
    }
}
