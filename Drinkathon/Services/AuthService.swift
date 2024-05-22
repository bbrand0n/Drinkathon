//
//  AuthService.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/7/24.
//

import Firebase
import FirebaseFirestoreSwift
import FirebaseMessaging

class AuthService {
    
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await UserService.shared.fetchCurrentUser()
            
            print("DEBUG: Logged in user \(result.user.uid)")
        } catch {
            print("DEBUG: Failed to sign in user with error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String, fullName: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            try await uploadUserData(withEmail: email, fullname: fullName, username: username, id: result.user.uid)
            
        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        // Signs out on backend
        try? Auth.auth().signOut()
        
        // Removes local user session
        self.userSession = nil
        UserService.shared.reset()
    }
    
    @MainActor
    private func uploadUserData(
        withEmail email: String,
        fullname: String,
        username: String,
        id: String
    ) async throws {
         let fcmToken = try await Messaging.messaging().token()
        let user = User(id: id, fullname: fullname, email: email, username: username, fcmToken: fcmToken, challenges: [])
        guard let userData = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection("users").document(id).setData(userData)
        
        UserService.shared.currentUser = user
    }
}
