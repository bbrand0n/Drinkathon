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
                    CreateChallengeView()
            })
            .padding(.horizontal)
        }
        .background(.darkerBlue)
    }
}

#Preview {
    let profileView = ProfileView(user: DeveloperPreview.shared.user1)
    return profileView
}
