//
//  ChallengeFeedView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/9/24.
//

import SwiftUI

struct ChallengeFeedView: View {
    @StateObject var viewModel: ChallengeFeedViewModel
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: ChallengeFeedViewModel(user: user))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.challenges) { challenge in
                    ChallengeCellView(challenge: challenge)
                }
            }
        }
        .onAppear {
            Task { try await viewModel.fetchChallenges() }
        }
    }
}

#Preview {
    let challengeFeedView = ChallengeFeedView(user: DeveloperPreview.shared.user1)
    challengeFeedView.viewModel.challenges.append(DeveloperPreview.shared.challenge)
    return challengeFeedView
}
