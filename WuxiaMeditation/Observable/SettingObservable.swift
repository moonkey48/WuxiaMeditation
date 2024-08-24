//
//  SettingObservable.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 8/24/24.
//

import Foundation

class SettingObservable: ObservableObject {
    var firstTimeString: String {
        get {
            UserDefaults.standard.string(forKey: "firstTimeString") ?? "error"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "firstTimeString")
        }
    }
    var secondTimeString: String {
        get {
            UserDefaults.standard.string(forKey: "secondTimeString") ?? "error"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "secondTimeString")
        }
    }
    var thirdTimeString: String {
        get {
            UserDefaults.standard.string(forKey: "thirdTimeString") ?? "error"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "thirdTimeString")
        }
    }
    var breathSpeed: Double {
        get {
            UserDefaults.standard.double(forKey: "breathSpeed")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "breathSpeed")
        }
    }

    var isHapticOn: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isHapticOn")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "isHapticOn")
        }
    }
    var selectedMusic: String {
        get {
            UserDefaults.standard.string(forKey: "selectedMusic") ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "selectedMusic")
        }
    }
    
    @Published var isEditMode = false
    @Published var firstTime = Date()
    @Published var secondTime = Date()
    @Published var thirdTime = Date()
    
    @Published var isShowWuxiaInfo = false
    @Published var isMusicSelect = false
    
    private let hapticManager: HapticInterface?
    private let audioPlayManager: AudioPlayInterface
    private let notificationManager: NotificationInterface
    
    init() {
        hapticManager = HapticManager()
        audioPlayManager = AudioPlayManager()
        notificationManager = NotificationManager()
        audioPlayManager.playSound(sound: UserDefaults.standard.string(forKey: "selectedMusic"))
    }
    
    
}
