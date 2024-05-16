//
//  UserHistory.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/15/24.
//

import SwiftUI

struct UserHistoryView: View {
    @StateObject var viewModel: UserHistoryViewModel
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: UserHistoryViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            ForEach(viewModel.challengesHistory) { challenge in
                ChallengeCellView(challenge: challenge)
                    .padding([.bottom])
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.darkerBlue)
    }
}

#Preview {
    UserHistoryView(
        user: DeveloperPreview.shared.user1
    )
}