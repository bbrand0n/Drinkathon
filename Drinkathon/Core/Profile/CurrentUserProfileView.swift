//
//  CurrentUserProfileView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/7/24.
//

import SwiftUI

struct CurrentUserProfileView: View {
    @StateObject var viewModel = CurrentUserProfileViewModel()
    @State private var showEditProfile = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Profile header
            if let user = viewModel.currentUser {
                ProfileHeaderView(user: user)
            }
            
            VStack {

                // Show edit profile
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
                
                // Sign out
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
            .padding()
            .background(.lighterBlue)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            VStack(alignment: .center) {
                Text("History")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Divider().overlay(.gray).padding(.horizontal, 100)
            }
            
            // User history
            ScrollView(showsIndicators: false) {
                if let user = viewModel.currentUser {
                    UserHistoryView(user: user)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    Text("No previous challenges to show")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom,45)
            
        }
        
        // Edit profile sheet
        .sheet(isPresented: $showEditProfile, content: {
            if let user = viewModel.currentUser {
                EditProfileView(user: user)
            }
        })
        .padding(.horizontal)
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.darkerBlue)
    }
}

#Preview {
    let profileView = CurrentUserProfileView()
    return profileView
}
