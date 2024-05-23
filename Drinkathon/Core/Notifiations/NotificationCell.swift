//
//  NotificationCell.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/22/24.
//

import SwiftUI

struct NotificationCell: View {
    @State var notification: PushNotification
    
    var body: some View {
        Group {
            HStack {
                Image(systemName: "gamecontroller")
                    .resizable()
                    .frame(width: 30, height: 20)
                    .foregroundStyle(.neonGreen)
                    .padding(.horizontal, 7)
                VStack(alignment: .trailing) {
                    HStack(alignment: .top) {
                        
                        
                        Text(notification.sender)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Text("challenged you!")
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                    Text(notification.time.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption2)
                        .foregroundStyle(.gray)
                        .padding(.top, 2)
                }
            }
        }
        .padding()
        .background(.lighterBlue)
        
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
        
    }
}

#Preview {
    let notificaiton = PushNotification(sender: "bbrand0n", receiver: "bdizzle", time: Date.now)
    let cell = NotificationCell(notification: notificaiton)
    return cell
}
