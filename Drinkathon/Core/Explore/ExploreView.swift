//
//  ExploreView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/7/24.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel = ExploreViewModel()
    @State private var searchText = ""
    @Binding var tab: Int
    @Binding var doneCreateChallenge: Bool
    
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
            .padding(.top, 100)
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user, doneCreateChallenge: self.$doneCreateChallenge, tab: self.$tab)
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
    let tabView = DrinkTabView()
    let exploreView = ExploreView(tab: tabView.$selectedTab, doneCreateChallenge: tabView.$doneCreateChallenge)
    return exploreView
}
