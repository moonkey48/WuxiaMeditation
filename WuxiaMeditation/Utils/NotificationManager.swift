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

protocol NotificationInterface {
    func sendNotification(dateList: [Date]) -> Void
    func requestPermission() -> Void
}

struct NotificationManager: NotificationInterface {
    func sendNotification(dateList: [Date]) -> Void {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        var notifications = [Notification]()
        for date in dateList { notifications.append(Notification(date: date)) }
        scheduleNotifications(notifications)
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .provisional, .sound, .criticalAlert, .providesAppNotificationSettings], completionHandler: { granted, error in
        })
    }
    
    private func scheduleNotifications(_ notifications: [Notification]) -> Void {
        for notification in notifications {
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.hour = Calendar.current.component(.hour, from: notification.date)
            dateComponents.minute = Calendar.current.component(.minute, from: notification.date)

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
}
