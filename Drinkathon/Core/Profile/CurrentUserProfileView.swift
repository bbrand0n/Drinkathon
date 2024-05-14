//
//  CurrentUserProfileView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/7/24.
//

import SwiftUI

struct CurrentUserProfileView: View {
    let currentUser: User?
    @State private var showEditProfile = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                        
                    if let user = currentUser {
                        ProfileHeaderView(user: user)
                    }
                    
                    Spacer()
                    
                    Button {
                        showEditProfile.toggle()
                    } label: {
                        Text("Edit Profile")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(width: 320, height: 44)
                            .background(Color(.systemGray4))
                            .cornerRadius(8)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            }
                    }
                    
                    Button {
                        AuthService.shared.signOut()
                    } label: {
                        Text("Log Out")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(width: 320, height: 44)
                            .background(Color.primaryBlue)
                            .cornerRadius(8)
                    }
                }
                .frame(maxWidth: .infinity)
                .sheet(isPresented: $showEditProfile, content: {
                    if let user = currentUser {
                        EditProfileView(user: user)
                    }
                })
                .padding(.horizontal)
                .padding(.top)
            }
            .background(.darkerBlue)
        }
    }
}

#Preview {
    let profileView = CurrentUserProfileView(currentUser: DeveloperPreview.shared.user1)
//    profileView.viewModel.currentUser = DeveloperPreview.shared.user1
    return profileView
}
