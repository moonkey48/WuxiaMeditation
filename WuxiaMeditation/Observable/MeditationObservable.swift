//
//  MeditationObservable.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 6/17/24.
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

@Observable
final class MeditationObservable {
    var meditationState: MeditationState = .notStarted
    var timeForRotating: Float = 0
    var timeForScale: Float = 0
    var timerForMeditation: Timer?
    
    var isMeditationDoneOnTime = false
    var energyState: EnergyState = .level0
    var currentWuxiaTime: WuxiaTime = Date().wuxiaTime
    var meditationSentence: MeditationSentence = dummyMeditationSentenceList[0]
    var isShowEndMeditationAlert = false
    var futureData: Date?
    var selectedMeditaionRange: MeditationRange = .smallMeditation
    var timerCount: Int = 0
    var meditationTimeRemaining: String = ""
    
    var breathStateDescription: BreathState? {
        let dump = Int(timeForScale) % (BreathState.inhaleExhale * 2 + BreathState.pauseGap * 2)
        
        if dump >= BreathState.pauseGap && dump < BreathState.inhaleExhale + BreathState.pauseGap {
            return .exhale
        } else if dump >= BreathState.inhaleExhale + BreathState.pauseGap * 2 &&
                    dump < BreathState.inhaleExhale * 2 + BreathState.pauseGap * 2 {
            return .inhale
        }
        return nil
    }
    
    
    init() {
//        AudioPlayManager.shared.playSound(sound: "meditation")
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self]_ in
            self?.timeForRotating += 0.1
        }
    }
    
    var isFinishedMeditation: Bool {
        selectedMeditaionRange.time * 60 > timerCount ? false : true
    }
}

// EneryLevel
extension MeditationObservable {
    // TODO: 어떤 기능을 위한 함수이지
    func checkWuxiaTimeChanged() {
        let newDate = Date.now
        if currentWuxiaTime != newDate.wuxiaTime {
            isMeditationDoneOnTime = false
        }
        currentWuxiaTime = newDate.wuxiaTime
    }
    
    func setMeditationStarted(_ meditationRange: MeditationRange) {
        withAnimation {
            selectedMeditaionRange = meditationRange
            timerForMeditation = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self]_ in
                self?.timeForScale += 0.1
            }
            futureData = Calendar.current.date(byAdding: .minute, value: selectedMeditaionRange.time, to: Date()) ?? Date()
            updateTimeRemaining()
            timerCount = 0
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                self.updateTimeRemaining()
                self.timerCount += 1
                if self.timerCount % 10 == 0 {
                    self.updateMeditaionSentence()
                }
            }
            meditationState = .preparing
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.meditationState = .progressing
            }
        }
    }
}


// Meditation
extension MeditationObservable {
    func setMeditationEnded() {
        timeForScale = 0
        withAnimation {
            timerForMeditation?.invalidate()
            calculateEnergyLevel()
            isMeditationDoneOnTime = true
            meditationState = .preparing
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.meditationState = .notStarted
            }
        }
    }
    
    private func calculateEnergyLevel() {
        if timerCount > selectedMeditaionRange.time * 60 / 2 {
            energyState = EnergyState(rawValue: energyState.rawValue - 1 >= 0 ? energyState.rawValue - 1  : 0) ?? energyState
        } else if timerCount > selectedMeditaionRange.time * 60 {
            if energyState.rawValue - 2 >= 0 {
                energyState = EnergyState(rawValue: energyState.rawValue - 2) ?? energyState
            } else if energyState.rawValue - 1 >= 0 {
                energyState = EnergyState(rawValue: energyState.rawValue - 1) ?? energyState
            }
        }
    }
    
    private func updateMeditaionSentence() {
        withAnimation {
            meditationSentence = dummyMeditationSentenceList.randomElement() ?? dummyMeditationSentenceList[0]
        }
    }
    
    private func updateTimeRemaining() {
        guard let futureData else {
            meditationTimeRemaining = "남은 시간 계산 오류"
            return
        }
        let remaining = Calendar.current.dateComponents([.minute, .second], from: Date(), to: futureData)
        let minute = remaining.minute ?? 0
        let second = remaining.second ?? 0
        meditationTimeRemaining = "\(minute)분 \(second)초 후"
    }
}
