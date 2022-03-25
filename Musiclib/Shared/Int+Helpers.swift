//
//  Int+Helpers.swift
//  Musiclib
//
//  Created by mlunts on 22.03.2022.
//

import Foundation

extension Int {
    var durationString: String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]

        if self >= 3600 {
            formatter.allowedUnits.insert(.hour)
        }
        
        return formatter.string(from: TimeInterval(self))!
    }
}
