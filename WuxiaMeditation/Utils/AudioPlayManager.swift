//
//  AudioPlayManager.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 6/15/24.
//

import AVFoundation

protocol AudioPlayInterface {
    func playSound(sound: String?) -> Void
}

class AudioPlayManager: AudioPlayInterface {
    static var musicList: [String] = [
        "Amber_VYEN",
        "LordOfTheDawn_JesseGallagher",
        "Seclusion_TheTides",
        "Somnolent_TheTides",
        "SpentaMainyu_JesseGallagher",
        "TheSleepingProphet_JesseGallagher",
        "ThinPlaces_JesseGallagher",
        "Tratak_JesseGallagher",
        "Venkatesananda_JesseGallagher"
    ]
    
    private var audioPlayer: AVAudioPlayer?
    
    func playSound(sound: String? = musicList[0]) {
        if let path = Bundle.main.path(forResource: sound, ofType: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
//                audioPlayer?.play()
            } catch {
                
            }
        }
    }
}
