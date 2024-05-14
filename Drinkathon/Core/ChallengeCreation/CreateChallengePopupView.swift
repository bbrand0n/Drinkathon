//
//  CreateChallengePopupView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/14/24.
//

import SwiftUI

struct CreateChallengePopupView: View {
    @Environment(\.dismiss) var dismiss
    @State var doneCreateChallenge = false
    
    var body: some View {
        NavigationStack {
            VStack {
                CreateChallengeView(done: self.$doneCreateChallenge)
            }
            .onChange(of: self.doneCreateChallenge) {
                dismiss()
            }
            // Navigation stuff
            .navigationTitle("New Challenge")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.lighterBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        Task {
                            dismiss()
                        }
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                }
            }
        }
        
    }
}

#Preview {
    CreateChallengePopupView()
}
