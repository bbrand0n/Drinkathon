//
//  ChallengeService.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/8/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct ChallengeService {
    
    @MainActor
    static func uploadChallenge(_ challenge: Challenge) async throws -> String {
        guard let challengeData = try? Firestore.Encoder().encode(challenge) else { return "" }
        let ref = try await Firestore.firestore().collection("challenges").addDocument(data: challengeData)
        
        try await UserService.sendNotification(challenge: challenge)
        
        return ref.documentID
    }
    
    @MainActor
    static func fetchAllChallenges() async throws -> [Challenge] {
        let snapshot = try await Firestore
            .firestore()
            .collection("challenges")
            .order(by: "timeSent", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: Challenge.self) })
    }
    
    @MainActor
    static func fetchUserChallengeIDs(uid: String) async throws -> [String] {
        let snapshot = try await Firestore
            .firestore()
            .collection("users")
            .document(uid)
            .getDocument()
        
        guard let challengeIds = snapshot.get("challenges") as? [String] else { return [] }
        return challengeIds
    }
    
    @MainActor
    static func fetchUserHistoryIDs(uid: String) async throws -> [String] {
        let snapshot = try await Firestore
            .firestore()
            .collection("users")
            .document(uid)
            .getDocument()
        
        guard let challengeIds = snapshot.get("history") as? [String] else { return [] }
        return challengeIds
    }
    
    @MainActor
    static func finishChallenge(challenge: Challenge) async throws {
 
        let winner = calculateWinner(challenge: challenge)
        print("Finish challenge: \(winner)")
        
        try await Firestore
                    .firestore()
                    .collection("challenges")
                    .document(challenge.id).updateData([
                        "status": "finished",
                        "winner": winner
                    ])
        
        // Update players history
        try await updateUserChallengeHistory(uid: challenge.player1.id, challengeId: challenge.id)
        try await updateUserChallengeHistory(uid: challenge.player2.id, challengeId: challenge.id)
    }
    
    @MainActor
    static func updateUserChallengeHistory(uid: String, challengeId: String) async throws {
        print("Updating user challenge history")
        
        try await Firestore.firestore().collection("users")
            .document(uid)
            .updateData([
                "challenges": FieldValue.arrayRemove([challengeId]),
                "history": FieldValue.arrayUnion([challengeId])
            ])
    }
    
    @MainActor
    static func cleanChallenges() async throws {
        
        // Get challenge IDs to query
        guard let challengeIds = UserService.shared.currentUser?.challenges else {
            print("No user challenges CleanChallenges")
            return
        }
        if challengeIds.isEmpty{
            print("No user challenges CleanChallenges")
            return
        }
        
        let date = Timestamp()
        print("Cleaning \(challengeIds.count) challenges")
        
        Firestore
            .firestore()
            .collection("challenges")
            .whereFilter(Filter.andFilter([
                Filter.whereField(FieldPath.documentID(), in: challengeIds),
                Filter.whereField("timeToEnd", isLessThanOrEqualTo: date)
            ]))
            .getDocuments(completion: { querySnapshot, error in
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                
                guard let docs = querySnapshot?.documents else { return }
                
                for doc in docs {
                    Task {
                        
                        // Get challenge
                        let challenge = try doc.data(as: Challenge.self)
                        
                        print("Found challenge to clean \(challenge.id)")
                        
                        try await finishChallenge(challenge: challenge)
                    }
                }
            })
    }
    
    @MainActor
    static func fetchUserChallenges(challengeIds: [String]) async throws -> [Challenge] {
        guard !challengeIds.isEmpty else { return [] }
        let snapshot = try await Firestore
            .firestore()
            .collection("challenges")
            .whereField(FieldPath.documentID(), in: challengeIds)
            .order(by: "timeToEnd", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: Challenge.self) })
    }
    
    @MainActor
    static func fetchUserHistory(uid: String) async throws -> [Challenge] {
        guard let ids = try? await fetchUserHistoryIDs(uid: uid) else { return [] }
        if ids.isEmpty { return [] }
        let snapshot = try await Firestore
            .firestore()
            .collection("challenges")
            .whereField(FieldPath.documentID(), in: ids)
            .order(by: "timeToEnd", descending: true)
            .getDocuments()
        
        
        return snapshot.documents.compactMap({ try? $0.data(as: Challenge.self) })
    }
    
    @MainActor
    static func removeLastDrink(challengeIds: [String]) async throws {
        guard let uid = UserService.shared.currentUser?.id else {
            print("ChallengeService: no UID in logNewDrink")
            return
        }
        guard !challengeIds.isEmpty else {
            print("ChallengeService: No active challenges")
            return
        }
        
        // TODO: gotta be a better way to do this...
        
        // If we are player 1
        let snapshot1 = try await Firestore
            .firestore()
            .collection("challenges")
            .whereField(FieldPath.documentID(), in: challengeIds)
            .whereField("status", isEqualTo: "active")
            .whereFilter(Filter.orFilter([
                Filter.whereField("player1.id", isEqualTo: uid)
            ]))
            .getDocuments().documents
        
        snapshot1.forEach { document in
            Task {
                try await Firestore.firestore().collection("challenges").document(document.documentID).updateData([
                    "player1.score": FieldValue.increment(Int64(-1))
                ])}
        }
        
        // If we are player 2
        let snapshot2 = try await Firestore
            .firestore()
            .collection("challenges")
            .whereField(FieldPath.documentID(), in: challengeIds)
            .whereField("status", isEqualTo: "active")
            .whereFilter(Filter.orFilter([
                Filter.whereField("player2.id", isEqualTo: uid)
            ]))
            .getDocuments().documents
        
        snapshot2.forEach { document in
            Task {
                try await Firestore.firestore().collection("challenges").document(document.documentID).updateData([
                    "player2.score": FieldValue.increment(Int64(-1))
                ])
            }
        }
    }
    
    @MainActor
    static func logNewDrink(challengeIds: [String]) async throws {
        guard let uid = UserService.shared.currentUser?.id else {
            print("ChallengeService: no UID in logNewDrink")
            return
        }
        guard !challengeIds.isEmpty else {
            print("ChallengeService: No active challenges")
            return
        }
        
        // TODO: gotta be a better way to do this...
        
        // If we are player 1
        let snapshot1 = try await Firestore
            .firestore()
            .collection("challenges")
            .whereField(FieldPath.documentID(), in: challengeIds)
            .whereField("status", isEqualTo: "active")
            .whereFilter(Filter.orFilter([
                Filter.whereField("player1.id", isEqualTo: uid)
            ]))
            .getDocuments().documents
        
        snapshot1.forEach { document in
            Task {
                try await Firestore.firestore().collection("challenges").document(document.documentID).updateData([
                    "player1.score": FieldValue.increment(Int64(1))
                ])}
        }
        
        // If we are player 2
        let snapshot2 = try await Firestore
            .firestore()
            .collection("challenges")
            .whereField(FieldPath.documentID(), in: challengeIds)
            .whereField("status", isEqualTo: "active")
            .whereFilter(Filter.orFilter([
                Filter.whereField("player2.id", isEqualTo: uid)
            ]))
            .getDocuments().documents
        
        snapshot2.forEach { document in
            Task {
                try await Firestore.firestore().collection("challenges").document(document.documentID).updateData([
                    "player2.score": FieldValue.increment(Int64(1))
                ])
            }
        }
    }
    
    @MainActor
    static func deleteChallenge(challenge: Challenge) async throws {
        
        // Delete from collection
        try await Firestore.firestore()
            .collection("challenges")
            .document(challenge.id)
            .delete()
        
        // Remove for player1
        try await removeChallengeFromUser(uid: challenge.player1.id, challengeId: challenge.id)
        
        // Remove for player2
        try await removeChallengeFromUser(uid: challenge.player2.id, challengeId: challenge.id)
    }
    
    @MainActor
    static func removeChallengeFromUser(uid: String, challengeId: String) async throws {
        
        // Remove from challenges and history
        try await Firestore.firestore()
            .collection("users")
            .document(uid)
            .updateData([
                "challenges": FieldValue.arrayRemove([challengeId]),
                "history": FieldValue.arrayRemove([challengeId])
            ])
    }
    
    @MainActor
    static func updateChallengeTime(_ cid: String, newTime: Date) async throws {
        try await Firestore.firestore()
            .collection("challenges")
            .document(cid)
            .updateData([
                "timeToEnd": newTime
            ])
    }
    
    static func calculateWinner(challenge: Challenge) -> String {
        var winner: String

        // Calculate winner
        if challenge.player1.score > challenge.player2.score {
            winner = challenge.player1.id
        } else if challenge.player1.score < challenge.player2.score {
            winner = challenge.player2.id
        } else {
            winner = "tie"
        }
        
        return winner
    }
    
    static func getWinnerUsername(challenge: Challenge) -> String {
        var winner: String

        // Calculate winner
        if challenge.player1.score > challenge.player2.score {
            winner = challenge.player1.username
        } else if challenge.player1.score < challenge.player2.score {
            winner = challenge.player2.username
        } else {
            winner = "Tie"
        }
        
        return winner
    }
}
