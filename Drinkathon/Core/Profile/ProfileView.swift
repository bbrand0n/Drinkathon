//
//  ProfileView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI

struct ProfileView: View {
    let user: User
    @Binding var selectedTab: Int
    @State private var showCreateChallenge = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
            
            VStack(alignment: .center) {
                Text("History")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Divider().overlay(.gray).padding(.horizontal, 100)
            }
            
            ScrollView(showsIndicators: false) {
                UserHistoryView(user: user)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.bottom, 45)
        }
        .onChange(of: self.selectedTab) {
            showCreateChallenge = false
        }
        .sheet(isPresented: $showCreateChallenge, content: {
            
            VStack(alignment: .center) {
                Spacer()
                
                // Challenge box
                CreateChallengeView(selectedTab: self.$selectedTab)
                    .padding(.top)
                    .padding(.bottom)
                
                Spacer()
                
                // Cancel button
                Button {
                    self.showCreateChallenge = false
                } label: {
                    Text("Cancel")
                        .font(.subheadline)
                        .padding()
                        .fontWeight(.semibold)
                }
                .background(.lighterBlue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.darkerBlue)
        })
        .padding(.horizontal)
        .padding(.top, 20)
        .background(.darkerBlue)
    }
}

#Preview {
    let tabView = DrinkTabView()
    
    let profileView = ProfileView(
        user: DeveloperPreview.shared.user1,
        selectedTab: tabView.$selectedTab
    )
    
    return profileView
}
