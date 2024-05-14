//
//  CreateChallengeTabView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/14/24.
//

import SwiftUI

struct CreateChallengeTabView: View {
    @Binding var done: Bool
    
    var body: some View {
        VStack {
            CreateChallengeView(done: self.$done)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.darkerBlue)
    }
}

#Preview {
    let tabView = DrinkTabView()
    let createView = CreateChallengeTabView(done: tabView.$doneCreateChallenge)

    return createView
}
