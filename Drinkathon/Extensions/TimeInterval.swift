//
//  TimeInterval.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/23/24.
//

import Foundation

extension TimeInterval {
    func format(using units: NSCalendar.Unit) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self) ?? ""
    }
}
