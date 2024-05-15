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
    static func cleanChallenges() async throws {
        let date = Timestamp()
        
        Firestore
            .firestore()
            .collection("challenges")
            .whereField("timeToEnd", isLessThanOrEqualTo: date)
            .getDocuments(completion: { querySnapshot, error in
                if let err = error {
                    print(err.localizedDescription)
                    return
                }

                guard let docs = querySnapshot?.documents else { return }

                for doc in docs {
                    let ref = doc.reference
                    var winner: String = "none"
                    
                    Task {
                        let challenge = try doc.data(as: Challenge.self)
                        if challenge.player1.score > challenge.player2.score {
                            winner = challenge.player1.id
                        }
                        else if challenge.player1.score < challenge.player2.score{
                            winner = challenge.player2.id
                        }
                        else {
                            winner = "tie"
                        }
                        print("winner: \(winner)")
                        
                        // Update winner and status
                        ref.updateData(["winner": winner])
                        ref.updateData(["status": "finished"])
                        
                        // Update players profiles
                        Firestore.firestore().collection("users")
                            .document(challenge.player1.id)
                            .updateData([
                                "challenges": FieldValue.arrayRemove([challenge.id]),
                                "history": FieldValue.arrayUnion([challenge.id])
                            ])
                        Firestore.firestore().collection("users")
                            .document(challenge.player2.id)
                            .updateData([
                                "challenges": FieldValue.arrayRemove([challenge.id]),
                                "history": FieldValue.arrayUnion([challenge.id])
                            ])
                    }
                    
                    
                }
            })
        
//        print("active: \(snapshot.count)")
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
        let date = Timestamp()
        
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
                    "player1.score": FieldValue.increment(Int64(1))])
            }
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
                    "player2.score": FieldValue.increment(Int64(1))])
            }
        }
    }
}
