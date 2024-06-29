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

extension MeditationState {
    static let standardMinute: Int = 10
}

@Observable
final class MeditationObservable {
    var meditationState: MeditationState = .notStarted
    
    var isMeditationDoneOnTime = false
    var energyState: EnergyState = .level0
    var currentWuxiaTime: WuxiaTime = Date().wuxiaTime
    var meditationSentence: MeditationSentence = dummyMeditationSentenceList[0]
    var isShowEndMeditationAlert = false
    var futureData: Date = Calendar.current.date(byAdding: .minute, value: MeditationState.standardMinute, to: Date()) ?? Date()
    var timerCount: Int = 0
    var meditationTimeRemaining: String = ""
    
    init() {
        AudioPlayManager.shared.playSound(sound: "meditation")
    }
    
    var isFinishedMeditation: Bool {
        MeditationState.standardMinute * 60 > timerCount ? false : true
    }
}

// EneryLevel
extension MeditationObservable {
    func checkWuxiaTimeChanged() {
        let newDate = Date.now
        if currentWuxiaTime != newDate.wuxiaTime {
            isMeditationDoneOnTime = false
        }
        currentWuxiaTime = newDate.wuxiaTime
    }
    
    func setMeditationStarted() {
        withAnimation {
            futureData = Calendar.current.date(byAdding: .minute, value: MeditationState.standardMinute, to: Date()) ?? Date()
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
        withAnimation {
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
        if timerCount > MeditationState.standardMinute * 60 / 2 {
            energyState = EnergyState(rawValue: energyState.rawValue - 1 >= 0 ? energyState.rawValue - 1  : 0) ?? energyState
        } else if timerCount > MeditationState.standardMinute * 60 {
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
        let remaining = Calendar.current.dateComponents([.minute, .second], from: Date(), to: futureData)
        let minute = remaining.minute ?? 0
        let second = remaining.second ?? 0
        meditationTimeRemaining = "\(minute)분 \(second)초 후"
    }
}
