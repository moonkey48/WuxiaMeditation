//
//  WuxiaTime.swift
//  WuxiaMeditation
//
//  Created by Austin's Macbook Pro M3 on 6/15/24.
//

import SwiftUI

enum WuxiaTime: Int, CaseIterable {
    case state0
    case state1
    case state2
    case state3
    case state4
    case state5
    case state6
    case state7
    case state8
    case state9
    case state10
    case state11
    
    var timeDescription: String {
        switch self {
        case .state0: "자시子時"
        case .state1: "축시子時"
        case .state2: "인시寅時"
        case .state3: "묘시卯時"
        case .state4: "진시辰時"
        case .state5: "사시巳時"
        case .state6: "오시午時"
        case .state7: "미시未時"
        case .state8: "신시申時"
        case .state9: "유시酉時"
        case .state10: "술시戌時"
        case .state11: "해시亥時"
        }
    }
    
    var timeRange: ClosedRange<Int> {
        switch self {
        case .state0: 23...24
        case .state1: 1...3
        case .state2: 3...5
        case .state3: 5...7
        case .state4: 7...9
        case .state5: 9...11
        case .state6: 11...13
        case .state7: 13...15
        case .state8: 15...17
        case .state9: 17...19
        case .state10: 19...21
        case .state11: 21...23
        }
    }
    
    var titleDescriptionBeforeMeditation: String {
        switch self {
        case .state0, .state1, .state2:
            "\(self.timeDescription)입니다.\n오늘 하루를 돌아보며,\n운기조식을 통해\n탁한 기를 내보내세요."
        case .state4,.state5, .state6:
            "\(self.timeDescription)입니다.\n하루를 시작하기 전,\n운기조식을 통해\n마음을 정돈하세요."
        case .state9, .state10, .state11:
            "\(self.timeDescription)입니다.\n오늘의 일을 정리하고\n운기조식을 통해\n휴식 전 하루를 돌아보세요."
        default:
            "\(self.timeDescription)입니다.\n운기조식을 통해\n마음을 정돈하세요."
        }
    }
    
    var titleDescriptionAfterMeditation: String {
        "\(self.timeDescription) 운기조식을 마쳤습니다.\n일과 삶이 태극을 이루듯,\n몸과 마음의 조화를 이루는\n하루가 되길 바랍니다. "
    }
}
