//
//  CurrentUserProfileView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/7/24.
//

import SwiftUI

struct CurrentUserProfileView: View {
    @ObservedObject var rootModel: MainTabViewModel
    @State private var showEditProfile = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            if let user = rootModel.currentUser{
                ProfileHeaderView(user: user)
                    .padding(.bottom)
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
                        .background(Color(.white))
                        .opacity(0.8)
                        .cornerRadius(8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.darkerBlue), lineWidth: 1)
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
            VStack {
                if let user = rootModel.currentUser {
                    UserHistoryView(user: user)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.bottom,45)
        }
        
        // Edit profile sheet
        .sheet(isPresented: $showEditProfile, content: {
            if let user = rootModel.currentUser {
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
    let mainView = MainTabView()
    let profileView = CurrentUserProfileView(rootModel: mainView.viewModel)
    return profileView
}
