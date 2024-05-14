//
//  Challenge.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import Firebase
import FirebaseFirestoreSwift

enum Status: String, Codable {
  case active = "active"
  case finished = "finished"
}

public struct Challenge: Identifiable, Codable {
    @DocumentID var challengeId: String?
    let ownerId: String
    let title: String
    let timeSent: Timestamp
    let timeToEnd: Date
    var status: Status = .active
    var winner: String? = "none"
    
    public var id: String {
        return challengeId ?? NSUUID().uuidString
    }
    
    var player1: Player
    var player2: Player

    var owner: User?
}
