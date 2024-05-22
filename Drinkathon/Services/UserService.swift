//
//  UserService.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/7/24.
//

import Firebase
import FirebaseFirestoreSwift
import FirebaseMessaging

class UserService: ObservableObject {
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    init() {
        Task { try await fetchCurrentUser() }
    }
    
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("UserService: No current user in fetchCurrentUser")
            return
        }
        print("UserService: Fetching user")
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        
        if let fcmToken = currentUser?.fcmToken
        {
            print("FCM token: \(fcmToken)")
        } else {
            try await updateUserFcmToken()
        }
        self.currentUser = user
    }
    
    @MainActor
    func updateUserFcmToken() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                let fcmToken = token
                print("Updated FCM Token: \(fcmToken)")
                
                Task {
                    try await Firestore.firestore().collection("users").document(uid).updateData([
                        "fcmToken" : fcmToken
                    ])
                }
            }
        }
    }
    
    @MainActor
    func updateCurrentUserProfile(fullname: String, bio: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await Firestore.firestore().collection("users").document(uid).updateData([
            "fullname" : fullname,
            "bio" : bio
        ])
    }
    
    @MainActor
    static func fetchUsers() async throws -> [User] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        let users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        
        return users.filter({ $0.id != currentUid })
    }
    
    @MainActor
    static func fetchUser(withUid uid: String) async throws -> User? {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    @MainActor
    func updateUserProfileImage(withImageUrl imageUrl: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        try await Firestore.firestore().collection("users").document(currentUid).updateData([
            "profileImageUrl": imageUrl
        ])
        self.currentUser?.profileImageUrl = imageUrl
    }
    
    func reset() {
        self.currentUser = nil
    }
    
    @MainActor
    static func addUserChallenge(uid: String, cid: String) async throws {
        let userRef = Firestore.firestore().collection("users").document(uid)
        
        try await userRef.updateData([
            "challenges": FieldValue.arrayUnion([cid])
        ])
    }
    
    @MainActor
    static func removeUserChallenge(uid: String, cid: String) async throws {
        let userRef = Firestore.firestore().collection("users").document(uid)
        
        try await userRef.updateData([
            "challenges": FieldValue.arrayRemove([cid])
        ])
    }
    
    @MainActor
    static func sendNotification(challenge: Challenge) async throws {
        var senderId: String
        var receiverId: String
        
        if self.shared.currentUser?.id == challenge.player1.id {
            senderId = challenge.player1.username
            receiverId = challenge.player2.id
        } else {
            senderId = challenge.player2.username
            receiverId = challenge.player1.id
        }
        
        let notification = PushNotification(sender: senderId, receiver: receiverId, time: Date.now)
        
        guard let notificationData = try? Firestore.Encoder().encode(notification) else { return }
        
        try await Firestore.firestore().collection("users")
            .document(receiverId)
            .collection("notifications")
            .addDocument(data: notificationData)
    }
    
    @MainActor
    static func deleteNotification(_ id: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        try await Firestore.firestore().collection("users")
            .document(uid)
            .collection("notifications")
            .document(id)
            .delete()
    }
}
