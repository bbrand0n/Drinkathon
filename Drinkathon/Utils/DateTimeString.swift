//
//  DateTimeString.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/22/24.
//

import Foundation

struct DateTimeString {
    // Time formatter
    static var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropLeading
        return formatter
    }()
}
