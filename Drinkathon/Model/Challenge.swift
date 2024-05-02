//
//  Challenge.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import Foundation

public struct Entry: Identifiable {
    public let id = UUID()
    public let name: String
    public let amount: Int
}
