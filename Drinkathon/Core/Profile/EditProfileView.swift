//
//  EditProfileView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/7/24.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @StateObject var viewModel: EditProfileViewModel
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: EditProfileViewModel(user: user))
    }
    
    @State private var fullname = ""
    @State private var bio = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                VStack {
                    PhotosPicker(selection: $viewModel.selectedItem) {
                        if let image = viewModel.profileImage {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width:40, height: 40)
                                .clipShape(Circle())
                        } else {
                            CircleProfilePictureView(user: viewModel.user, size: .xLarge)
                        }
                    }
                    
                    Divider()
                        .overlay(.gray)
                        .padding(.top, 10)
                        .padding(.bottom, 8)
                    
                    // Name
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Name")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                            
                            TextField("", text: $fullname,
                                      prompt: Text("Full name").foregroundStyle(.gray))
                            .foregroundStyle(.white)
                        }
                        .font(.footnote)
                        
                        Spacer()
                    }
                    
                    Divider()
                        .overlay(.gray)
                        .padding(.bottom, 8)
                    
                    VStack(alignment: .leading) {
                        Text("Bio")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        
                        TextField("", text: $bio,
                                  prompt: Text("Add bio...").foregroundStyle(.gray))
                        .foregroundStyle(.white)
                    }
                    .font(.footnote)
                }
                .font(.footnote)
                .padding()
                .background(.lighterBlue)
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                }
                .padding()
            }
            .onAppear {
                self.fullname = viewModel.user.fullname
                self.bio = viewModel.user.bio ?? ""
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        
                        Task{
                            try await viewModel.updateUserData(fullname: fullname, bio: bio)
                            dismiss()
                        }
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.darkerBlue)
        }
    }
}

#Preview {
    let profileView = EditProfileView(user: DeveloperPreview.shared.user1)
    return profileView
}
