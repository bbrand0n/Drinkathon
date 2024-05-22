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
    
    let user1 = User(id: NSUUID().uuidString, fullname: "Brandon Gibbons", email: "brandon@gmail.com", username: "bgibbons", bio: "Bestest enginr evr", fcmToken: "", challenges: [])
    let user2 = User(id: NSUUID().uuidString, fullname: "Draolen Tripe", email: "sonvsdf@gmail.com", username: "dtripe", fcmToken: "", challenges: [])
    var playas = [Player]()
    var challenge1: Challenge
    var challenge2: Challenge
    var challenge3: Challenge
    var drinks1 = [Drink]()
    var drinks2 = [Drink]()
    
    init() {
        
//        drinks1.append(Drink(time: Date.now, drink: 0))
        drinks1.append(Drink(time: Date.now.advanced(by: 2342), drink: 1))
        drinks1.append(Drink(time: Date.now.advanced(by: 2360), drink: 2))
        drinks1.append(Drink(time: Date.now.advanced(by: 4029), drink: 3))
//        drinks1.append(Drink(time: Date.now.advanced(by: 5029), drink: 4))
//        drinks1.append(Drink(time: Date.now.advanced(by: 6029), drink: 5))
        
//        drinks2.append(Drink(time: Date.now, drink: 0))
        drinks2.append(Drink(time: Date.now.advanced(by: 3092), drink: 1))
        drinks2.append(Drink(time: Date.now.advanced(by: 4029), drink: 2))
        drinks2.append(Drink(time: Date.now.advanced(by: 5092), drink: 3))
//        drinks2.append(Drink(time: Date.now.advanced(by: 6029), drink: 4))
//        drinks2.append(Drink(time: Date.now.advanced(by: 7029), drink: 5))
//        drinks2.append(Drink(time: Date.now.advanced(by: 8094), drink: 6))
        
        playas.append(Player(id: "iwbcw", username: user1.username, score: 5, user: user1, drinks: drinks1))
        playas.append(Player(id: "eivun", username: user2.username, score: 2, user: user2, drinks: drinks2))

        
        
        challenge1 = Challenge(ownerId: user1.id, title: "Challenge1", timeSent: Timestamp(), timeToEnd: Date.now.advanced(by: 30984), player1: playas[0], player2: playas[1])
        
        challenge2 = Challenge(ownerId: user1.id, title: "Challenge2", timeSent: Timestamp(), timeToEnd: Date.now.advanced(by: 30984), player1: playas[0], player2: playas[1])
        
        challenge3 = Challenge(ownerId: user1.id, title: "Challenge3", timeSent: Timestamp(), timeToEnd: Date.now.advanced(by: -30984), status: .finished, player1: playas[0], player2: playas[1])
        
    }
}
