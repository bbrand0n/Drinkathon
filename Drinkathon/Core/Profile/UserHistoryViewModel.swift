//
//  UserHistoryViewModel.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/15/24.
//

import Foundation
import Combine
import Firebase

class UserHistoryViewModel : ObservableObject {
    @Published var challengesHistory = [Challenge]()
    
    @MainActor
    func fetchUserHistory(_ uid: String) async throws {
        print("UserHistoryViewModel: fetching history")
        
        self.challengesHistory = try await ChallengeService.fetchUserHistory(uid: uid)
    }
}
