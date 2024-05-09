//
//  LoginViewModel.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/7/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func login() async throws {
        try await AuthService.shared.login(withEmail: email, password: password)
    }
}
