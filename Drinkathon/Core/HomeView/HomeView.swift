//
//  HomeView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(0 ... 10, id: \.self) { challenge in
                        ChallengeCell()
                    }
                }
            }
            .refreshable {
                print("DEBUG: refresh home")
            }
            .navigationTitle("Recent Challenges")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    HomeView()
}
