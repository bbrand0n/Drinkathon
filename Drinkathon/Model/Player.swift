//
//  Player.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/8/24.
//

import Firebase
import FirebaseFirestoreSwift

struct Player: Identifiable, Codable {
    var id: String
    var username: String
    var score: Int = 0
    
    var user: User?
    var drinks: [Drink]?
}

public struct Drink: Identifiable, Codable, Hashable {
    public var id = UUID()
    let time: Date
    let drink: Int
}

