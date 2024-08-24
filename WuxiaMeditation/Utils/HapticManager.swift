//
//  HapticManager.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 8/10/24.
//

import CoreHaptics
import Foundation

protocol HapticInterface {
    
}

final class HapticManager {
    
    private let engine: CHHapticEngine
    private var player: CHHapticPatternPlayer?

    init?() {
        do {
            let capablitity = CHHapticEngine.capabilitiesForHardware()
            
            if capablitity.supportsHaptics {
                let engine = try CHHapticEngine()
                self.engine = engine
                try engine.start()
                print("haptic manager return.")
            } else {
                print("haptic manager nil.")
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    deinit {
        stop()
        engine.stop()
    }
    
    func startHaptic(_ totalSeconds: Int) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        
        var events = [CHHapticEvent]()
        let minutes: Int = totalSeconds / 60
        for i in stride(from: 0, to: Double(totalSeconds), by: 1) {
            let time: Int = Int(i.truncatingRemainder(dividingBy: (Double(BreathState.inhaleExhale) + Double(BreathState.pauseGap)) * 2))
            if 
                time == 0 ||
                time == BreathState.pauseGap ||
                time == BreathState.pauseGap + BreathState.inhaleExhale ||
                time == BreathState.pauseGap * 2 + BreathState.inhaleExhale ||
                time == BreathState.pauseGap * 2 + BreathState.inhaleExhale * 2 {
                
                let value: Float = 0.5
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: value)
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: value)
                let relativeTime: TimeInterval = i * 3.0 / UserDefaults.standard.double(forKey: "breathSpeed") 
                let eventFirst = CHHapticEvent(eventType: .hapticTransient, parameters: [
                    intensity,
                    sharpness,
                ], relativeTime: relativeTime)
                let eventSecond = CHHapticEvent(eventType: .hapticTransient, parameters: [
                    intensity,
                    sharpness,
                ], relativeTime: relativeTime + 0.2)
                events.append(eventFirst)
                events.append(eventSecond)
            }
        }
        
        startEvents(events)
    }
    
    private func startEvents(_ events: [CHHapticEvent]) {
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            player = try engine.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func stop() {
        try? player?.stop(atTime: 0)
    }
}
