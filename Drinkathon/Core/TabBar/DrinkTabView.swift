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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                
                ExploreView(selectedTab: self.$selectedTab)
                    .tag(1)
                
                CreateChallengeTabView(selectedTab: self.$selectedTab)
                    .tag(2)
                
                NotificationsView(selectedTab: self.$selectedTab)
                    .tag(3)
                
                CurrentUserProfileView()
                    .tag(4)
            }
            .ignoresSafeArea(edges: .bottom)
            .background(.lighterBlue)
            
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
