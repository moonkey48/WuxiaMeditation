//
//  Date+.swift
//  WuxiaMeditation
//
//  Created by Austin's Macbook Pro M3 on 6/15/24.
//

import SwiftUI

extension Date {
    var wuxiaTime: WuxiaTime {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        for wuxiaTime in WuxiaTime.allCases {
            if wuxiaTime.timeRange ~= hour {
                return wuxiaTime
            }
        }
        return .state0
    }
    
    var hourAndMinute: String {
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "HH:mm"
        return dateFormmater.string(from: self)
    }
}
