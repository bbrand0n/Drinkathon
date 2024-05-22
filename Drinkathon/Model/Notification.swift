//
//  Notification.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/21/24.
//
import Firebase
import FirebaseFirestoreSwift

struct PushNotification: Identifiable, Codable, Hashable {
    @DocumentID var challengeId: String?
    let sender: String
    let receiver: String
    let time: Date
    
    public var id: String {
        return challengeId ?? NSUUID().uuidString
    }
}
