//
//  EditProfileViewModel.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/7/24.
//

import PhotosUI
import SwiftUI

class EditProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { await loadImage() } }
    }
    @Published var profileImage: Image?
    private var uiImage: UIImage?
    
    init(user: User)
    {
        self.user = user
    }
    
    @MainActor
    private func loadImage() async {
        guard let item = selectedItem else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
    private func updateProfileImage() async throws {
        guard let image = self.uiImage else { return }
        guard let imageUrl = try? await ImageUploader.uploadImage(image) else { return }
        try await UserService.shared.updateUserProfileImage(withImageUrl: imageUrl)
    }
    
    @MainActor
    func updateUserData(fullname: String, bio: String) async throws {
        self.user.fullname = fullname
        self.user.bio = bio
        
        try await updateProfileImage()
        try await UserService.shared.updateCurrentUserProfile(fullname: fullname, bio: bio)
    }
}
