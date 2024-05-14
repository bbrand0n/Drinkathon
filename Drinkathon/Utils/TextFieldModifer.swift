//
//  TextFieldModifer.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI

struct TextFieldModifer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.lighterBlue))
            .cornerRadius(10)
            .padding(.horizontal, 24)
    }
}
