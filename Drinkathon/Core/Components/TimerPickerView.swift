//
//  TimerPickerView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/8/24.
//

import SwiftUI

struct TimerPickerView: View {
    // This is used to tighten up the spacing between the Picker and its
    // respective label
    //
    // This allows us to avoid having to use custom
    private let pickerViewTitlePadding: CGFloat = 2.0
    
    let title: String
    let range: ClosedRange<Int>
    let binding: Binding<Int>
    
    var body: some View {
        HStack(spacing: -pickerViewTitlePadding) {
            Picker(title, selection: binding) {
                ForEach(range, id: \.self) { timeIncrement in
                    HStack {
                        // Forces the text in the Picker to be right-side
                        Text("\(timeIncrement)")
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .pickerStyle(InlinePickerStyle())
            .labelsHidden()
            .frame(width: 75, height: 100)
            
            Text(title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    @State var hours = 10
    let timerView = TimerPickerView(title: "Hours", range: 0...23, binding: $hours)
    return timerView
}
