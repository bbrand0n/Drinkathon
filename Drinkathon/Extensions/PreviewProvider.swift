//
//  PreviewProvider.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/7/24.
//

import SwiftUI
import Firebase

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let user1 = User(id: NSUUID().uuidString, fullname: "Brandon Gibbons", email: "brandon@gmail.com", username: "bgibbons", bio: "Bestest enginr evr", challenges: [])
    let user2 = User(id: NSUUID().uuidString, fullname: "Draolen Tripe", email: "sonvsdf@gmail.com", username: "dtripe", challenges: [])
    var playas = [Player]()
    var challenge1: Challenge
    var challenge2: Challenge
    var challenge3: Challenge
    
    init() {
        playas.append(Player(id: "iwbcw", username: user1.username, score: 5, user: user1))
        playas.append(Player(id: "eivun", username: user2.username, score: 0, user: user2))
        
        challenge1 = Challenge(ownerId: user1.id, title: "Challenge1", timeSent: Timestamp(), timeToEnd: Date.now.advanced(by: 30984), player1: playas[0], player2: playas[1])
        
        challenge2 = Challenge(ownerId: user1.id, title: "Challenge2", timeSent: Timestamp(), timeToEnd: Date.now.advanced(by: 30984), player1: playas[0], player2: playas[1])
        
        challenge3 = Challenge(ownerId: user1.id, title: "Challenge3", timeSent: Timestamp(), timeToEnd: Date.now.advanced(by: -30984), status: .finished, player1: playas[0], player2: playas[1])
        
    }
}
