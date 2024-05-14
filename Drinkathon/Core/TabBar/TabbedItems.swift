//
//  TabbedItems.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/14/24.
//

import Foundation

enum TabbedItems: Int, CaseIterable {
    case home = 0
    case explore
    case create
    case notifications
    case profile
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .explore:
            return "Explore"
        case .create:
            return "Create"
        case .notifications:
            return "Notifications"
        case .profile:
            return "Profile"
        }
    }
    
    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .explore:
            return "magnifyingglass"
        case .create:
            return "plus"
        case .notifications:
            return "bell"
        case .profile:
            return "person"
        }
    }
}
