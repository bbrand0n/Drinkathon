//
//  PlayerCell.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/7/24.
//

import SwiftUI

struct AddPlayerCell: View {
    @EnvironmentObject var parentViewModel: CreateChallengeViewModel
    let user: User
    
    @State var userSelected = false
    
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
            
            Button {
                // Add or Remove users from selected list
                if (!parentViewModel.selectedUsers.contains(user))
                {
                    parentViewModel.selectedUsers.append(user)
                    print("DEBUG: Added to selected users: \(user.username)")
                    
                } else {
                    
                    parentViewModel.selectedUsers.removeAll(){$0.username == user.username}
                    print("DEBUG: Removed from selected users: \(user.username)")
                    
                }
                userSelected.toggle()
            } label: {
                if userSelected
                {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(Color(.cyan))
                    
                } else {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(Color(.blue))
                }
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
    
    let playerCell = AddPlayerCell(user: DeveloperPreview.shared.user1).environmentObject(CreateChallengeViewModel())
    return playerCell
}
