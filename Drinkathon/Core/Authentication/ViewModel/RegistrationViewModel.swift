//
//  RegistrationViewModel.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/7/24.
//

import Foundation


class RegistrationViewModel : ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var username = ""
    
    func createUser() async throws {
        try await AuthService.shared.createUser(
            withEmail: email,
            password: password,
            fullName: fullname,
            username: username
        )
    }
}
