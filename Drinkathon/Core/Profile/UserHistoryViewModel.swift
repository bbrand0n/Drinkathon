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
    
    private var cancellables = Set<AnyCancellable>()
    
    init(user: User) {
        self.currentUser = user
        Task { try await fetchHistory() }
    }
    
    @MainActor
    func fetchHistory() async throws {

        // Get challenge IDs to query
        let historyIds = try await ChallengeService.fetchUserHistoryIDs(uid: currentUser.id)
        if historyIds.isEmpty { return }
        
        // Add listener to user history
        Firestore.firestore().collection("users").document(currentUser.id)
            .addSnapshotListener { querySnapshot, error in
                
                do {
                    guard let user = try querySnapshot?.data(as: User.self) else { return }
                    self.currentUser = user
                } catch {
                    print("Error decoding user")
                }
            }
        
        // Add snapshot to our challenges
        Firestore.firestore().collection("challenges").whereField(FieldPath.documentID(), in: historyIds)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching challenge history \(error!)")
                    return
                }
                
                // Get updated data
                self.challengesHistory = documents.compactMap({ try? $0.data(as: Challenge.self) })
                
                // Populate user data if it is new
                querySnapshot?.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        Task { try await self.fetchUserDataForChallenges() }
                    }
                }
            }
    }
    
    @MainActor
    private func fetchUserDataForChallenges() async throws {
        for i in 0 ..< self.challengesHistory.count {
            
            // Redundant check to make sure array didnt change during execution
            if i < self.challengesHistory.endIndex {
                let challenge = challengesHistory[i]
                let uid1 = challenge.player1.id
                let uid2 = challenge.player2.id
                let p1User = try await UserService.fetchUser(withUid: uid1)
                let p2User = try await UserService.fetchUser(withUid: uid2)
                
                // Redundant check to make sure array didnt change during execution
                if i < self.challengesHistory.endIndex{
                    challengesHistory[i].player1.user = p1User
                    challengesHistory[i].player2.user = p2User
                }
            }
        }
    }
}
