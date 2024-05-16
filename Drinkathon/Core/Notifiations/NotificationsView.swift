//
//  NotificationsView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/14/24.
//

import SwiftUI

struct NotificationsView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack {
            Text("Hello, Notifications!")
            
            Button {
                selectedTab = 0
            } label: {
                Text("Send me to Home tab")
            }
            Button {
                selectedTab = 1
            } label: {
                Text("Send me to Explore tab")
            }
            Button {
                selectedTab = 2
            } label: {
                Text("Send me to Create Exercise tab")
            }
            Button {
                selectedTab = 4
            } label: {
                Text("Send me to Profile tab")
            }
        }
        
    }
}

#Preview {
    let tabView = DrinkTabView()
    let notificationsView = NotificationsView(selectedTab: tabView.$selectedTab)
    return notificationsView
}
