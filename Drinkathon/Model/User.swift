//
//  User.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/7/24.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: String
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl: String?
    var bio: String?
    
    var challenges: [String]?
    var history: [String]?
}


