//
//  HomeViewModel.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/8/24.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift

class HomeViewModel: ObservableObject {
    @Published var challenges = [Challenge]()
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
        Task { try await fetchChallenges() }
    }
    
    private func setupSubscribers() {
        UserService.shared.$currentUser.sink{ [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)

    }
    
    @MainActor
    func fetchChallenges() async throws {
        // Update current user
        guard let uid = currentUser?.id else { return }
        
        Firestore.firestore().collection("users").document(uid)
            .addSnapshotListener { docSnapshot, error in
                guard let document = docSnapshot else {
                    print("Error fetching user \(error!)")
                    return
                }

                Task { try self.currentUser = document.data(as: User.self) }
                
            }
        
        // Get challenge IDs to query
        guard let challengeIds = currentUser?.challenges else { return }
        if challengeIds.isEmpty { return }
        
        // Add snapshot to our challenges
        Firestore.firestore().collection("challenges").whereField(FieldPath.documentID(), in: challengeIds)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching challenges \(error!)")
                    return
                }
                
                // Get updated data
                self.challenges = documents.compactMap({ try? $0.data(as: Challenge.self) })
                Task { try await self.fetchUserDataForChallenges() }
            }
        
        // Populate user data
        try await fetchUserDataForChallenges()
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
    
    @MainActor
    func incrementDrink() async throws {
        guard let id = currentUser?.id else { return }
        guard let challenges = currentUser?.challenges else { return }
        try await ChallengeService.logNewDrink(uid: id, challengeIds: challenges)
        
        print("DEBUG: Fetch challenges called")
    }
    
}
