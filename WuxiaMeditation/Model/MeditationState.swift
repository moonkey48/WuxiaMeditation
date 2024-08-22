//
//  MeditationState.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 8/4/24.
//

import SwiftUI

enum MeditationState {
    case notStarted
    case preparing
    case progressing
}

enum MeditationRange {
    case smallMeditation
    case bigMeditation
    
    var time: Int {
        switch self {
        case .smallMeditation:
            1
        case .bigMeditation:
            10
        }
    }
}

enum BreathState {
    case inhale
    case exhale
    case pause
    
    static let inhaleExhale: Int = 5
    static let pauseGap: Int = 2
    
    var wuxiaDescription: String {
        switch self {
        case .inhale: "흡 吸"
        case .exhale: "호 呼"
        case .pause: ""
        }
    }
}

extension BreathState {
    static func getBreathSpeedDescription(_ breathSpeed: Double) -> String {
        if breathSpeed < 2 {
            return "아주 천천히"
        } else if breathSpeed == 2.0 {
            return "천천히"
        } else if breathSpeed == 3.0 {
            return "보통 속도로"
        } else if breathSpeed == 4.0 {
            return "빠르게"
        } else if breathSpeed == 5.0 {
            return "아주 빠르게"
        } else {
            return "속도 에러"
        }
    }
}
