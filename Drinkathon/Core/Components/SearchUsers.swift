//
//  SearchUsers.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/8/24.
//

import SwiftUI

struct SearchUsers: View {
    @EnvironmentObject var parentViewModel: CreateChallengeViewModel
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(parentViewModel.usersList) { user in
                        AddPlayerCell(user: user)
                    }
                }
                
            }
            .navigationTitle("Add Players")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.lighterBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .searchable(text: $searchText, prompt: "Search")
            
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                }
            }
            .background(.darkerBlue)
        }
    }
}

#Preview {
    let parentViewModel = CreateChallengeViewModel()
    parentViewModel.usersList.append(DeveloperPreview.shared.user1)
    parentViewModel.usersList.append(DeveloperPreview.shared.user2)
    let searchView = SearchUsers().environmentObject(parentViewModel)
    return searchView
}
