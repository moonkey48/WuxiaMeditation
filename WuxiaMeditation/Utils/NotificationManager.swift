//
//  NotificationManager.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 6/17/24.
//

import SwiftUI
import UserNotifications

struct Notification {
    var id: String = UUID().uuidString
    var date: Date
}

class NotificationManager: ObservableObject {
    @Published var notifications = [Notification]()
    
    init() {
        requestPermission()
    }
    
    private func requestPermission(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .provisional, .sound, .criticalAlert, .providesAppNotificationSettings], completionHandler: { granted, error in
        })
    }
    
    func sendNotification(dateList: [Date]) -> Void {
        for date in dateList { notifications.append(Notification(date: date)) }
        schedule()
    }
    
    func schedule() -> Void {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                self.requestPermission()
            }
        }
    }
    
    func scheduleNotifications() -> Void {
        for notification in notifications {
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.hour = Calendar.current.component(.hour, from: notification.date)
            dateComponents.minute = Calendar.current.component(.minute, from: notification.date)
            print(Calendar.current.component(.hour, from: notification.date))

            
            let content = UNMutableNotificationContent()
            content.title = "\(notification.date.wuxiaTime.timeDescription)입니다."
            content.sound = UNNotificationSound.defaultRingtone
            content.subtitle = "운기조식하실 시간입니다."
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
            }
        }
    }
    
    func reScheduleNotifications(_ dateList: [Date]) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        sendNotification(dateList: dateList)
    }
}
