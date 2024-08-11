//
//  HapticManager.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 8/10/24.
//

import CoreHaptics
import Foundation


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
    
    func hapticOnPoints(_ meditationRange: MeditationRange) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        
        var events = [CHHapticEvent]()
        let minutes: Int = meditationRange == .smallMeditation ? 60 : 60 * 5
        for i in stride(from: 0, to: Double(meditationRange.time) * Double(minutes), by: 1) {
            let time: Int = Int(i.truncatingRemainder(dividingBy: (Double(BreathState.inhaleExhale) + Double(BreathState.pauseGap)) * 2))
            if 
                time == 0 ||
                time == BreathState.pauseGap ||
                time == BreathState.pauseGap + BreathState.inhaleExhale ||
                time == BreathState.pauseGap * 2 + BreathState.inhaleExhale ||
                time == BreathState.pauseGap * 2 + BreathState.inhaleExhale * 2 {
                
                let value: Float = 2.0
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: value)
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: value)
                let eventFirst = CHHapticEvent(eventType: .hapticTransient, parameters: [
                    intensity,
                    sharpness,
                ], relativeTime: i)
                let eventSecond = CHHapticEvent(eventType: .hapticTransient, parameters: [
                    intensity,
                    sharpness,
                ], relativeTime: i + 0.2)
                events.append(eventFirst)
                events.append(eventSecond)
            }
        }
        
        startEvents(events)
    }
    
    func hapticStrongToSlow(_ meditationRange: MeditationRange) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        
        var events = [CHHapticEvent]() 
        
        for i in stride(from: 0, to: Double(meditationRange.time) * 60, by: 0.9) {

            let value: Float = calculateValue(i: i.truncatingRemainder(dividingBy: (Double(BreathState.inhaleExhale) + Double(BreathState.pauseGap)) * 2)) * 0.5 + 0.2
            
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: value)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: value)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [
                intensity,
                sharpness,
            ], relativeTime: i)
            events.append(event)
        }
        
        startEvents(events)
    }
    
    func calculateValue(i: Double) -> Float {
        print(i)
        if i >= Double(BreathState.pauseGap) && i < Double(BreathState.inhaleExhale) + Double(BreathState.pauseGap) {
            return Float(i) / Float(BreathState.inhaleExhale + BreathState.pauseGap)
        } else if i >= (Double(BreathState.inhaleExhale) + Double(BreathState.pauseGap)) && i < (Double(BreathState.inhaleExhale) + Double(BreathState.pauseGap) * 2) {
            return 1.0
        } else if i >= (Double(BreathState.inhaleExhale) + Double(BreathState.pauseGap) * 2) && i <= Double(BreathState.inhaleExhale) * 2 + Double(BreathState.pauseGap) * 2 {
            let dump = Float(i) - Float(Double(BreathState.inhaleExhale) + Double(BreathState.pauseGap) * 2)
            return (1.0 - (dump / Float(BreathState.inhaleExhale)))
        } else {
            return 0.1
        }
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
