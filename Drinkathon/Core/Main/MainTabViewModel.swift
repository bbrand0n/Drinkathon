//
//  DrinkTabViewModel.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/14/24.
//

import Foundation
import FirebaseFirestore
import SwiftUI

class MainTabViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var store = StoreProvider.challengeStore
    @Published var isLoading = false
    
    var userListener: ListenerRegistration?
    var challengeListener: ListenerRegistration?
    
    init() {
        Task {
            await listenToUser()
            await listenToChallenges()
            
            // Clean challlenges that ended while app was closed
            try await cleanChallenges()
            
            print("home init")
        }
    }
    
    @MainActor
    func listenToUser() {
        guard let uid = AuthService.shared.userSession?.uid else { return }
        print("Listener added: user")
        
        userListener = Firestore.firestore().collection("users").document(uid).addSnapshotListener{ documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching user from listener UserService")
                return
            }
            
            // Update current user
            do {
                // Update and listen to challenges
                if document.get("fcmToken") == nil {
                    Task {
                        try await UserService.shared.updateUserFcmToken()
                    }
                }
                self.currentUser = try document.data(as: User.self)
                self.listenToChallenges()
                
                print("TabView: Current user updated")
            } catch {
                print("Error decoding User in UserService")
            }
        }
    }
    
    @MainActor
    func listenToChallenges() {
        
        // Get challenge IDs to query
        guard let challengeIds = currentUser?.challenges else {
            print("No user to listen for challenges")
            challengeListener?.remove()
            return
        }
        
        // Ignore if challenges are empty
        if challengeIds.isEmpty {
            print("User challenges empty")
            challengeListener?.remove()
            return
        }
        
        // Refresh challenge listener
        if self.challengeListener != nil {
            print("Listener removed: Challenges")
            self.challengeListener?.remove()
        }
        
        print("Listener added: challenges")
        
        // Add snapshot to our challenges
        challengeListener = Firestore.firestore().collection("challenges").whereField(FieldPath.documentID(), in: challengeIds)
            .order(by: "timeSent", descending: true)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching challenges \(error!)")
                    return
                }
                
                // Populate user data if it is new
                Task {
                    self.store.challenges = documents.compactMap({ try? $0.data(as: Challenge.self) })
                }
            }
    }
    
    @MainActor
    private func fetchUserDataForChallenges() async throws {
        do {
            // Fill local challenges with user data
            for i in 0 ..< self.store.challenges.count {
                let challenge = self.store.challenges[i]
                let uid1 = challenge.player1.id
                let uid2 = challenge.player2.id
                let p1User = try await UserService.fetchUser(withUid: uid1)
                let p2User = try await UserService.fetchUser(withUid: uid2)
                
                self.store.challenges[i].player1.user = p1User
                self.store.challenges[i].player2.user = p2User
            }
        } catch {
            print("Out of bounds HomeView: \(error)")
        }
    }
    
    @MainActor
    func fetchChallenges() async throws {
        
        // Get challenge IDs to query
        guard let challengeIds = currentUser?.challenges else {
            print("MainTabView: No user challenges FetchChallenges")
            return
        }
        if challengeIds.isEmpty{
            print("MainTabView: No user challenges FetchChallenges")
            return
        }
        
        listenToChallenges()
    }
    
    @MainActor
    func incrementTime(cid: String, currentTimeToEnd: Date) async throws {
        // Add one hour to end time
        let cur = currentTimeToEnd
        let newTimeToEnd = cur.addingTimeInterval(3600)
        try await ChallengeService.extendChallengeTime(cid, newTime: newTimeToEnd)
    }
    
    @MainActor
    func decrementTime(cid: String, currentTimeToEnd: Date) async throws {
        // Subtract one hour from end time
        let timeLeft = currentTimeToEnd.addingTimeInterval(-3600)
        if timeLeft < Date.now {
            print("Not enough time left")
        } else {
            try await ChallengeService.extendChallengeTime(cid, newTime: timeLeft)
        }
        
    }
    
    @MainActor
    func cleanChallenges() async throws {
        try await ChallengeService.cleanChallenges()
    }
    
    @MainActor
    func incrementDrink() async throws {
        guard let challenges = currentUser?.challenges else { return }
        
        try await ChallengeService.logNewDrink(challengeIds: challenges)
    }
}
