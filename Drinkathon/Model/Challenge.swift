//
//  Challenge.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import Firebase
import FirebaseFirestoreSwift

public struct Challenge: Identifiable, Codable {
    @DocumentID var challengeId: String?
    let ownerId: String
    let title: String
    let timeSent: Timestamp
    let timeToEnd: Date
    
    
    public var id: String {
        return challengeId ?? NSUUID().uuidString
    }
    
//    var players: [String]
//    var scores: [Int]
    var player1: Player
    var player2: Player

    var owner: User?
}
