//
//  NotificationManager.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/20/24.
//

import Foundation
import UserNotifications

@MainActor
class NotificationManager: ObservableObject {
    @Published private(set) var hasPermission = false
    
    init() {
        Task {
            await getAuthStatus()
        }
    }
    
    func request() async {
        do {
            try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            await getAuthStatus()
        } catch {
            print(error)
        }
    }
    
    func getAuthStatus() async {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { status in
            switch status.authorizationStatus{
            case .authorized, .ephemeral, .provisional:
                self.hasPermission = true
            default:
                self.hasPermission = false
            }
        })
    }
}
