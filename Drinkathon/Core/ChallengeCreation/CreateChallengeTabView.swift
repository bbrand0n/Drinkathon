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
        VStack {
            CreateChallengeView(selectedTab: self.$selectedTab)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.darkerBlue)
    }
}

#Preview {
    let tabView = DrinkTabView()
    let createView = CreateChallengeTabView(selectedTab: tabView.$selectedTab)

    return createView
}
