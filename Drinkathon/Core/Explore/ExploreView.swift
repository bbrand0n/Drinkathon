//
//  ExploreView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/7/24.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel = ExploreViewModel()
    @Binding var selectedTab: Int
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.users) { user in
                        NavigationLink(value: user) {
                            PlayerCell(user: user)
                            
                            Divider()
                        }
                    }
                }
            }
            .padding(.top, 5)
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user, selectedTab: self.$selectedTab)
            })
            .navigationTitle("Find Friends")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.lighterBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search")
            .background(.darkerBlue)
        }
    }
}

#Preview {
    let tabView = MainTabView()
    let exploreView = ExploreView(selectedTab: tabView.$selectedTab)
    return exploreView
}
