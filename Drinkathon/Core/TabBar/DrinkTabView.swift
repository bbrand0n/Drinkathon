//
//  TabView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI

struct DrinkTabView: View {
    @StateObject var viewModel = DrinkTabViewModel()
    @State var selectedTab = 0
    @State var doneCreateChallenge = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                
                ExploreView(tab: self.$selectedTab, doneCreateChallenge: self.$doneCreateChallenge)
                    .tag(1)
                
                CreateChallengeTabView(done: self.$doneCreateChallenge)
                    .tag(2)
                
                NotificationsView()
                    .tag(3)
                
                CurrentUserProfileView(currentUser: viewModel.currentUser)
                    .tag(4)
            }
            .ignoresSafeArea(edges: .bottom)
            .background(.lighterBlue)
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//            .animation(.smooth(duration: 0.2), value: selectedTab)
            
            ZStack {
                HStack {
                    ForEach(TabbedItems.allCases, id: \.self) { item in
                        Button {
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
            .onChange(of: doneCreateChallenge) {
                if doneCreateChallenge == true {
                    selectedTab = 0
                    doneCreateChallenge = false
                }
            }
            .frame(height: 70)
            .background(.lighterBlue.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 35))
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    DrinkTabView()
}
