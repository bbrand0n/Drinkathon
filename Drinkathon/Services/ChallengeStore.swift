//
//  ChallengeStore.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/17/24.
//

import Foundation

class StoreProvider {
    static let challengeStore = ChallengeStore()
}

class ChallengeStore: ObservableObject {
    @Published var challenges = [Challenge]()
}
