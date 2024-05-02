//
//  CircleProfilePicture.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI

struct CircleProfilePictureView: View {
    var body: some View {
        Image(systemName: "person.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CircleProfilePictureView()
}
