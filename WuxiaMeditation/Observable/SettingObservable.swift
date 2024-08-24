//
//  SettingObservable.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 8/24/24.
//

import Foundation

class SettingObservable: ObservableObject {
    @UserDefault(key: "firstTimeString", defaultValue: "7:30")
    var firstTimeString: String {
        willSet { objectWillChange.send() }
    }
    
    @UserDefault(key: "secondTimeString", defaultValue: "18:00")
    var secondTimeString: String  {
        willSet { objectWillChange.send() }
    }
    
    @UserDefault(key: "thirdTimeString", defaultValue: "23:00")
    var thirdTimeString: String  {
        willSet { objectWillChange.send() }
    }
    
    @UserDefault(key: "breathSpeed", defaultValue: 3)
    var breathSpeed: Double  {
        willSet { objectWillChange.send() }
    }
    
    @UserDefault(key: "isHapticOn", defaultValue: true)
    var isHapticOn: Bool  {
        willSet { objectWillChange.send() }
    }
    
    @UserDefault(key: "selectedMusic", defaultValue: AudioPlayManager.musicList.first ?? "")
    var selectedMusic: String  {
        willSet { objectWillChange.send() }
    }
    
    @Published var isEditMode = false
    @Published var firstTime = Date()
    @Published var secondTime = Date()
    @Published var thirdTime = Date()
    
    @Published var isShowWuxiaInfo = false
    @Published var isMusicSelect = false
    
    init() { }
    
    func setDateFromUserDefaults() {
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "HH:mm"
        if let firstDate = dateFormmater.date(from: firstTimeString) {
            firstTime = firstDate
        }
        if let secondDate = dateFormmater.date(from: secondTimeString) {
            secondTime = secondDate
        }
        if let thirdDate = dateFormmater.date(from: thirdTimeString) {
            thirdTime = thirdDate
        }
    }
    
    func setUserDefaultsFromDates() {
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "HH:mm"
        firstTimeString = dateFormmater.string(from: firstTime)
        secondTimeString = dateFormmater.string(from: secondTime)
        thirdTimeString = dateFormmater.string(from: thirdTime)
        NotificationManager().sendNotification(dateList: [firstTime, secondTime, thirdTime])
    }
}
