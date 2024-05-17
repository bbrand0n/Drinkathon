//
//  AddFriendsView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI

struct CreateChallengeView: View {
    @StateObject var viewModel = CreateChallengeViewModel()
    @Binding var selectedTab: Int
    
    @State private var showSearchUsers = false
    @State private var title = ""
    @State private var selectedHoursAmount = 1
    @State private var selectedMinutesAnount = 30
    @State private var titleFocused = false
    
    var submitDisabled: Bool {
        title.isEmpty ||
        (viewModel.selectedUsers.count != 1) ||
        (selectedHoursAmount == 0 && selectedMinutesAnount == 0)
    }
    
    let hoursRange = 0...23
    let minutesRange = 0...59
    
    enum Field: Hashable { case title }
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack {
            Image("drink2")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 170)
            
            Divider()
                .overlay(.gray)
                .padding(.top, 5)
                .padding(.bottom, 5)
            
            // Title
            HStack {
                VStack(alignment: .leading) {
                    Text("Title")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    TextField("", text: $title,
                              prompt: Text("Title for your challenge").foregroundStyle(.gray))
                    .foregroundStyle(.white)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .title)
                }
                .font(.footnote)
                
                Spacer()
            }
            
            Divider()
                .overlay(.gray)
                .padding(.top, 5)
                .padding(.bottom, 5)
            
            // Competitors field
            VStack(alignment: .leading) {
                Text("Competitors")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                HStack {
                    if viewModel.selectedUsers.isEmpty {
                        
                        // No user selected yet
                        Text("None")
                            .foregroundStyle(.gray)
                        
                    } else {
                        
                        // Selected users
                        ForEach(viewModel.selectedUsers) { user in
                            CircleProfilePictureView(user: user, size: .xSmall)
                        }
                    }
                    
                    Spacer()
                    
                    // Add players
                    Button {
                        showSearchUsers.toggle()
                        focusedField = nil
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(Color(.blue))
                            .padding(.trailing, 3)
                    }
                }
            }
            .font(.footnote)
            
            Divider()
                .overlay(.gray)
                .padding(.top, 5)
                .padding(.bottom, 5)
            
            // Duration field
            VStack(alignment: .leading) {
                Text("Duration")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                HStack {
                    TimerPickerView(title: "hours", range: hoursRange, binding: $selectedHoursAmount)
                    
                    TimerPickerView(title: "minutes", range: minutesRange, binding: $selectedMinutesAnount)
                    
                    Spacer()
                    
                }
                .foregroundColor(.black)
            }
            .font(.footnote)
            
            Divider()
                .overlay(.gray)
                .padding(.top, 5)
                .padding(.bottom, 5)
            
            // Challenge button
            Button {
                focusedField = nil
                
                // Calculate date
                let seconds = (selectedHoursAmount * 60 * 60) + (selectedMinutesAnount * 60)
                let duration = Date.now.addingTimeInterval(TimeInterval(seconds))
                
                Task {
                    // Upload challenge
                    try await viewModel.uploadChallenge(title: title, timeToEnd: duration)
                    
                    // Switch back to Home
                    selectedTab = 0
                }
                
            } label: {
                Text("Challenge!")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(width: 320, height: 44)
                    .background(submitDisabled ? Color.gray : Color.primaryBlue)
                    .cornerRadius(8)
                    .padding(.top, 8)
            }
            .disabled(submitDisabled)
        }
        .font(.footnote)
        .padding()
        .background(.lighterBlue)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.midnightBlue, lineWidth: 1))
        .padding(30)
        
        // Search users sheet
        .sheet(isPresented: $showSearchUsers, content: {
            SearchUsers().environmentObject(viewModel)
        })
        
        // Reset fields when appeared
        .onAppear {
            title = ""
            viewModel.selectedUsers.removeAll()
            selectedHoursAmount = 1
            selectedMinutesAnount = 30
        }
    }
}

#Preview {
    let tabView = MainTabView()
    let createView = CreateChallengeView(selectedTab: tabView.$selectedTab)
    return createView
}
