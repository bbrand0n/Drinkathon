//
//  ContentViewModel.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/7/24.
//

import Foundation
import Combine
import Firebase

class ContentViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setUpSubscribers()
    }
    
    private func setUpSubscribers() {
        AuthService.shared.$userSession.sink {[weak self] userSession in
            self?.userSession = userSession
        }.store(in: &cancellables)
    }
}
