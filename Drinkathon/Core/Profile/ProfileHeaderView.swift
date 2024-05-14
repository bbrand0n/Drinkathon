//
//  ProfileHeaderView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/7/24.
//

import SwiftUI

struct ProfileHeaderView: View {
    var user: User?
    
    init(user: User?) {
        self.user = user
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(user?.fullname ?? "Empty")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.white)
                    
                    Text(user?.username ?? "Empty")
                        .font(.subheadline)
                        .foregroundStyle(Color.white)
                }
                if let bio = user?.bio {
                    Text(bio)
                        .font(.footnote)
                        .foregroundStyle(Color.white)
                }
            }
            
            Spacer()
            
            CircleProfilePictureView(user: user, size: .large)
        }
        .background(.darkerBlue)
    }
}

#Preview {
    let profileView = ProfileHeaderView(user: DeveloperPreview.shared.user1)
    return profileView
}
