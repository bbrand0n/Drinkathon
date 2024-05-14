//
//  ProfileView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI

struct ProfileView: View {
    let user: User
    @State private var showCreateChallenge = false
    @Binding var doneCreateChallenge: Bool
    @Binding var tab: Int
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                ProfileHeaderView(user: user)
                
                Spacer()
                
                Button {
                    showCreateChallenge.toggle()
                } label: {
                    Text("Challenge")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(width: 320, height: 44)
                        .background(Color.primaryBlue)
                        .cornerRadius(8)
                }
            }
            .sheet(isPresented: $showCreateChallenge, content: {
                CreateChallengeView(done: self.$doneCreateChallenge)
            })
            .padding(.horizontal)
        }
        .padding(.top, 20)
        .background(.darkerBlue)
    }
}

#Preview {
    let tabView = DrinkTabView()
    let profileView = ProfileView(user: DeveloperPreview.shared.user1, doneCreateChallenge: tabView.$doneCreateChallenge, tab: tabView.$selectedTab)
    return profileView
}
