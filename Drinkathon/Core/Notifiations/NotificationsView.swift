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
            VStack {
                Text("Hello, Notifications!")
                    .font(.title)
                    .foregroundStyle(.gray)
                
                Button {
                    selectedTab = 0
                } label: {
                    Text("Send me to Home tab")
                }.buttonStyle(BorderedButtonStyle())
                
                Button {
                    selectedTab = 1
                } label: {
                    Text("Send me to Explore tab")
                }.buttonStyle(BorderedButtonStyle())
                
                Button {
                    selectedTab = 2
                } label: {
                    Text("Send me to Create Exercise tab")
                }.buttonStyle(BorderedButtonStyle())
                
                Button {
                    selectedTab = 4
                } label: {
                    Text("Send me to Profile tab")
                }.buttonStyle(BorderedButtonStyle())
            }
            .padding()
            .background(.lighterBlue)
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.darkerBlue)
    }
}

#Preview {
    let tabView = MainTabView()
    let notificationsView = NotificationsView(selectedTab: tabView.$selectedTab)
    return notificationsView
}
