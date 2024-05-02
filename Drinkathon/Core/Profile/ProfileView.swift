//
//  ProfileView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            VStack(spacing: 20) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Brandon Gibbons")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("bbran0n")
                                .font(.subheadline)
                        }
                        Text("Software Engineer")
                            .font(.footnote)
                    }
                    
                    Spacer()
                    
                    CircleProfilePictureView()
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProfileView()
}
