//
//  NotificationsViewModel.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/22/24.
//

import Foundation
import FirebaseFirestore
import SwiftUI

class NotificationsViewModel: ObservableObject {
    @Published var notifications = [PushNotification]()
    @Published var unread = 0
    @Published var offsets = [CGSize]()
    
    init() {
        Task {
            await listenToNotifications()
        }
    }
    
    var notificationListener: ListenerRegistration?
    
    @MainActor
    func listenToNotifications() {
        guard let uid = AuthService.shared.userSession?.uid else { return }
        print("Listener added: notifications")
        
        notificationListener = Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("notifications")
            .order(by: "time", descending: true)
            .addSnapshotListener{ documentSnapshots, error in
                guard let documents = documentSnapshots else {
                    print("Error fetching user from listener UserService")
                    return
                }
                
                // Update current notifications
                self.notifications = documents.documents.compactMap({ try? $0.data(as: PushNotification.self) })
                self.offsets = [CGSize](repeating: CGSize.zero, count: self.notifications.count)
                
                print("NotificationsView: Notifications updated")
            }
    }
    
    @MainActor
    func deleteNotification(_ id: String) async throws {
        try await UserService.deleteNotification(id)
    }
}
