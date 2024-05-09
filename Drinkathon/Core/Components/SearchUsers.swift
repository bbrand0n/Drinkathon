//
//  SearchUsers.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/8/24.
//

import SwiftUI

struct SearchUsers: View {
    @EnvironmentObject var parentViewModel: CreateChallengeViewModel
    @State private var searchText = ""
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(parentViewModel.usersList) { user in
                        AddPlayerCell(user: user)
                        
                        Divider()
                    }
                    .padding(.vertical, 4)
                }
            
        }
        .searchable(text: $searchText, prompt: "Search")
    }
}

//#Preview {
//    let parentViewModel = CreateChallengeViewModel()
//    parentViewModel.usersList.append(DeveloperPreview.shared.user1)
//    let searchView = SearchUsers().environmentObject(parentViewModel)
//    return searchView
//}
