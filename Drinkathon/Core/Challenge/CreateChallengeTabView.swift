//
//  CreateChallengeTabView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/14/24.
//

import SwiftUI

struct CreateChallengeTabView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack {
            VStack {
                CreateChallengeView(selectedTab: self.$selectedTab)
            }
            .navigationTitle("Create Challenge")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.lighterBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.darkerBlue)
        }
        
        
    }
}

#Preview {
    let tabView = MainTabView()
    let createView = CreateChallengeTabView(selectedTab: tabView.$selectedTab)
    
    return createView
}
