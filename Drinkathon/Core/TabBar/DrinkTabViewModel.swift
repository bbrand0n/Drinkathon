//
//  DrinkTabViewModel.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/14/24.
//

import Foundation
import Combine

class DrinkTabViewModel: ObservableObject {
    @Published var currentUser: User?
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        UserService.shared.$currentUser.sink{ [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
    }
}
