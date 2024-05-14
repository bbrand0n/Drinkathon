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
    static func fetchUserChallenges(uid: String) async throws -> [Challenge] {
        guard let ids = try? await fetchUserChallengeIDs(uid: uid) else { return [] }
        let snapshot = try await Firestore
            .firestore()
            .collection("challenges")
            .whereField(FieldPath.documentID(), in: ids)
            .getDocuments()

        return snapshot.documents.compactMap({ try? $0.data(as: Challenge.self) })
    }
    
    @MainActor
    static func logNewDrink(uid: String, challengeIds: [String]) async throws {
        guard Auth.auth().currentUser != nil else { return }
        
        // If we are player 1
        let snapshot1 = try await Firestore
            .firestore()
            .collection("challenges")
            .whereField(FieldPath.documentID(), in: challengeIds)
            .whereFilter(Filter.orFilter([
                Filter.whereField("player1.id", isEqualTo: uid)
            ]))
            .getDocuments().documents
            
        snapshot1.forEach { document in
            Task {
                try await Firestore.firestore().collection("challenges").document(document.documentID).updateData([
                    "player1.score": FieldValue.increment(Int64(1))])
            }
        }
        
        // If we are player 2
        let snapshot2 = try await Firestore
            .firestore()
            .collection("challenges")
            .whereField(FieldPath.documentID(), in: challengeIds)
            .whereFilter(Filter.orFilter([
                Filter.whereField("player2.id", isEqualTo: uid),
            ]))
            .getDocuments().documents
        
        snapshot2.forEach { document in
            Task {
                try await Firestore.firestore().collection("challenges").document(document.documentID).updateData([
                    "player2.score": FieldValue.increment(Int64(1))])
            }
        }
    }
}
