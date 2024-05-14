//
//  TabbedView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/14/24.
//

import Foundation
import SwiftUI

extension DrinkTabView {
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View {
        HStack(spacing: 10) {
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(isActive ? Color.teal : Color.gray)
                .frame(width: 20, height: 20)
//            if isActive {
//                Text(title)
//                    .font(.system(size: 14))
//                    .foregroundStyle(isActive ? Color.lighterBlue : Color.gray)
//            }
            Spacer()
        }
        .frame(width: isActive ? 70 : 60, height: 60)
//        .background(isActive ? Color.teal.opacity(0.4) : Color.lighterBlue)
//        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}
