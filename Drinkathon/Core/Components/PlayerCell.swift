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
                
                Text(user.fullname)
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
                    .foregroundColor(Color(.black))
            }
            .padding(.leading, 5)
        }
        .padding(.horizontal)
    }
}

#Preview {
    let user = User(
        id: NSUUID().uuidString,
        fullname: "Brandon Gibbons",
        email: "brandon@gmail.com",
        username: "bgibbons",
        challenges: [])
    let playerCell = PlayerCell(user: user)
    return playerCell
}
