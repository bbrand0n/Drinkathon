//
//  NotificationsView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/14/24.
//

import SwiftUI

struct NotificationsView: View {
    @StateObject var viewModel = NotificationsViewModel()
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.notifications.isEmpty {
                    Text("No notifications")
                        .font(.title)
                        .foregroundStyle(.gray)
                    Image(systemName: "face.dashed.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.neonPink)
                        .opacity(0.6)
                } else {
                    ScrollView {
                        ForEach(viewModel.notifications.indices, id: \.self) { index in
                            HStack {
                                NotificationCell(notification: viewModel.notifications[index])
                                
                                Button {
                                    Task {
                                        Task {
                                            try await viewModel.deleteNotification(viewModel.notifications[index].id)
                                        }
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundStyle(.red)
                                }
                            }
                            .padding(.trailing, -40)
                            .offset(x: viewModel.offsets[index].width)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        viewModel.offsets[index] = gesture.translation
                                        if viewModel.offsets[index].width > 50 {
                                            viewModel.offsets[index] = .zero
                                        }
                                    }
                                    .onEnded { _ in
                                        if viewModel.offsets[index].width < -150 {
                                            Task {
                                                try await viewModel.deleteNotification(viewModel.notifications[index].id)
                                            }
                                        }
                                        else if self.viewModel.offsets[index].width < -50 {
                                            viewModel.offsets[index].width = -50
                                        }
                                    }
                            )
                        }
                        .padding(.trailing)
                    }
                    .padding(.top)
                    .padding(.bottom, 70)
                    .scrollIndicators(.visible)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.darkerBlue)
            .navigationTitle("Notifications")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.lighterBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.darkerBlue)
        }
    }
}

#Preview {
    let tabView = MainTabView()
    //    let notifications = [PushNotification(sender: "first", receiver: "iwwin", time: Date.now),
    //                         PushNotification(sender: "second", receiver: "iwwin", time: Date.now),
    //                         PushNotification(sender: "third", receiver: "iwwin", time: Date.now)]
    //    let notificationsView = NotificationsView(notifications: notifications, selectedTab: tabView.$selectedTab)
    let notificationsView = NotificationsView(selectedTab: tabView.$selectedTab)
    return notificationsView
}
