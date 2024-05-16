//
//  CurrentUserProfileViewModel.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/15/24.
//

import Foundation
import Combine
import Firebase

class CurrentUserProfileViewModel: ObservableObject {
    @Published var currentUser: User?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
        Task { try await fetchUser() }
    }
    
    private func setupSubscribers() {
        UserService.shared.$currentUser.sink{ [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
    }
    
    @MainActor
    func fetchUser() async throws {
        // Update current user
        guard let uid = currentUser?.id else {
            print("ERROR: No user ID in fetch challenges")
            return
        }
        
        self.currentUser = try await UserService.fetchUser(withUid: uid)
        
        // Get current user
        Firestore.firestore().collection("users").document(uid)
            .addSnapshotListener { docSnapshot, error in
                guard let document = docSnapshot else {
                    print("Error fetching user \(error!)")
                    return
                }
                
                do {
                    try self.currentUser = document.data(as: User.self)
                } catch {
                    print("Error decoding user in fetch challenges")
                }
            }
    }
}
