//
//  AddFriendsView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI

struct CreateChallengeView: View {
    @StateObject var viewModel = CreateChallengeViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showSearchUsers = false
    @State private var title = ""
    @State private var selectedHoursAmount = 10
    @State private var selectedMinutesAnount = 0
    
    let hoursRange = 0...23
    let minutesRange = 0...59
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea([.bottom, .horizontal])
                
                VStack {
                    
                    Divider()
                        .padding(.top, 10)
                        .padding(.bottom, 8)
                    
                    // Title
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Title")
                                .fontWeight(.semibold)
                            
                            TextField("Title for your challenge", text: $title)
                        }
                        .font(.footnote)
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    // Competitors field
                    VStack(alignment: .leading) {
                        Text("Competitors")
                            .fontWeight(.semibold)
                        
                        HStack {
                            // Selected users
                            ForEach(viewModel.selectedUsers) { user in
                                CircleProfilePictureView(user: user, size: .xSmall)
                            }
                            
//                            CircleProfilePictureView(user: DeveloperPreview.shared.user, size: .xSmall)
                            
                            Spacer()
                            
                            // Add players
                            Button {
                                showSearchUsers.toggle()
                            } label: {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(Color(.blue))
                                    .padding(.trailing, 3)
                            }
                        }
                    }
                    .font(.footnote)
                    
                    Divider()
                    
                    // Duration field
                    VStack(alignment: .leading) {
                        Text("Duration")
                            .fontWeight(.semibold)
                        
                        HStack {
                            TimerPickerView(title: "hours", range: hoursRange, binding: $selectedHoursAmount)
                            
                            TimerPickerView(title: "minutes", range: minutesRange, binding: $selectedMinutesAnount)
                            
                            Spacer()
                            
                        }
                        .foregroundColor(.black)
                    }
                    .font(.footnote)
                    
                    Divider()
                    
                    // Challenge button
                    Button {
                        
                        // Calculate date
                        let seconds = (selectedHoursAmount * 60 * 60) + (selectedMinutesAnount * 60)
                        let duration = Date.now.addingTimeInterval(TimeInterval(seconds))
                        
                        Task {
                            
                            // Upload challenge
                            try await viewModel.uploadChallenge(title: title, timeToEnd: duration)
                        }
                        
                        dismiss()
                    } label: {
                        Text("Challenge!")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(width: 320, height: 44)
                            .background(Color.primaryBlue)
                            .cornerRadius(8)
                            .padding(.top, 8)
                    }
                }
                .font(.footnote)
                .padding()
                .background(.white)
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                }
                .padding()
            }
            
            // Search users sheet
            .sheet(isPresented: $showSearchUsers, content: {
                SearchUsers().environmentObject(viewModel)
            })
            
            // Navigation stuff
            .navigationTitle("New Challenge")
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
    CreateChallengeView()
}
