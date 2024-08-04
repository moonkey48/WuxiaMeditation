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
            5
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
