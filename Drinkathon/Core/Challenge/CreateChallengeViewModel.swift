//
//  CreateChallengeViewModel.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/8/24.
//

import Foundation
import Firebase

class CreateChallengeViewModel: ObservableObject {
    @Published var usersList = [User]()
    @Published var selectedUsers = [User]()
    @Published var isLoading = false
    
    init() {
        // TODO: filter for friends only?
        Task { try await fetchUsers() }
    }
    
    @MainActor
    func uploadChallenge(title: String, timeToEnd: Date) async throws {
        try await UserService.shared.fetchCurrentUser()

        guard let currentUser = UserService.shared.currentUser else {
            print("ERROR: no current user selected")
            return
        }
        
        guard let opponent = selectedUsers.first else {
            print("Could not retriece opponent")
            return
        }
        
        // Set up players
        let player1 = Player(id: currentUser.id, username: currentUser.username, drinks: [Drink(time: Date.now, drink: 0)])
        let player2 = Player(id: opponent.id, username: opponent.username, drinks: [Drink(time: Date.now, drink: 0)])
        
        // Upload challenge to DB
        let challenge = Challenge(ownerId: currentUser.id, title: title, timeSent: Timestamp(), timeToEnd: timeToEnd, player1: player1, player2: player2)
        let challengeId = try await ChallengeService.uploadChallenge(challenge)
        
        // Add challenge to DB
        try await UserService.addUserChallenge(uid: player1.id, cid: challengeId)
        try await UserService.addUserChallenge(uid: player2.id, cid: challengeId)
    }
    
    @MainActor
    private func fetchUsers() async throws {
        self.usersList = try await UserService.fetchUsers()
    }
}
