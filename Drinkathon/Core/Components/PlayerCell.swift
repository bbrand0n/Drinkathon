//
//  PlayerCell.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/7/24.
//

import SwiftUI

struct PlayerCell: View {
    let user: User
    
    var body: some View {
        HStack {
            CircleProfilePictureView(user: user, size: .small)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(user.username)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.white)
                
                Text(user.fullname)
                    .foregroundStyle(Color.white)
            }
            .font(.footnote)
            
            Spacer()
            
            // TODO: add friend
            Button {
                
            } label: {
                // TODO: change this icon if they are already friends
                Image(systemName: "person.badge.plus")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(Color(.blue))
            }
        }
        .padding()
        .background(.lighterBlue)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.top)
        .padding(.horizontal, 10)
    }
}

#Preview {
    let playerCell = PlayerCell(user: DeveloperPreview.shared.user1)
    return playerCell
}
