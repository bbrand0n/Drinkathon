//
//  UserHistory.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/15/24.
//

import SwiftUI

struct UserHistoryView: View {
    @State var challengeHistory = [Challenge]()
    @State var user: User
    
    var isCurrentUser: Bool {
        return user.id == AuthService.shared.userSession?.uid ?? ""
    }
    
    var body: some View {
        ScrollView {
            ForEach(challengeHistory) { challenge in
                ChallengeHistoryCellView(challenge: challenge, currentUsername: user.username)
                .overlay(alignment: .trailingLastTextBaseline) {
                    if isCurrentUser {
                        Menu {
                            // Delete button
                            Button(role: .destructive) {
                                Task {
                                    try await ChallengeService.deleteChallenge(challenge: challenge)
                                    Task { challengeHistory = try await ChallengeService.fetchUserHistory(uid: user.id) }
                                }
                            } label: {
                                Label("Delete Challenge", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .clipShape(Circle())
                                .padding(.trailing, 35)
                        }
                    }
                }
                    .padding([.bottom])
            }
        }
        .onAppear {
            Task { challengeHistory = try await ChallengeService.fetchUserHistory(uid: user.id) }
        }
        .refreshable {
            Task { challengeHistory = try await ChallengeService.fetchUserHistory(uid: user.id) }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.darkerBlue)
    }
}

#Preview {

    let view = UserHistoryView(
        user: DeveloperPreview.shared.user1
    )
    return view
}
