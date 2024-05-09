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
    
    init() {
        // TODO: filter for friends only?
        Task { try await fetchUsers() }
    }
    
    @MainActor
    func uploadChallenge(title: String, timeToEnd: Date) async throws {
        try await UserService.shared.fetchCurrentUser()
        guard let uid = Auth.auth().currentUser?.uid else {
            print("ERROR: Could not get currentUser.uid from auth()")
            return
        }
        guard let currentUser = UserService.shared.currentUser else {
            print("ERROR: no current user selected")
            return
        }
        
        // Add owner to players
        selectedUsers.append(currentUser)
        
        // Convert the users to players
        var players = [Player]()
        selectedUsers.forEach{ user in
            players.append(Player(id: user.id, username: user.username))
        }
        
        // Upload challenge to DB
        let challenge = Challenge(ownerId: uid, title: title, timeSent: Timestamp(), timeToEnd: timeToEnd, player1: players[0], player2: players[1])
        let challengeId = try await ChallengeService.uploadChallenge(challenge)
        
        // Add challenge to DB
        selectedUsers.forEach{ user in
            Task{ try await UserService.addUserChallenge(uid: user.id, cid: challengeId) }
        }
        
    }
    
    @MainActor
    private func fetchUsers() async throws {
        self.usersList = try await UserService.fetchUsers()
    }
}
