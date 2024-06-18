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
    
    static func setNotifications(times: [Date]) {
        // TODO: SetNotification
    }
    
    func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    //we have permission!
                }
            }
    }
    
    func addNotification(date: Date) -> Void {
        // TODO: change date to WuxiaTime
        notifications.append(Notification(date: date))
    }
    
    func schedule() -> Void {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        }
    }
    
    func scheduleNotifications() -> Void {
        for notification in notifications {
            //🗓️ 날짜 설정
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.weekday = 4 // Wednesday
            dateComponents.hour = 19 // 14:00
            
            let content = UNMutableNotificationContent()
            content.title = "\(notification.date.wuxiaTime.timeDescription)입니다."
            content.sound = UNNotificationSound.default
            content.subtitle = "운기조식하실 시간입니다."
//            content.body = "먹었다고 체크하기"
//            content.summaryArgument = "summary argument"
//            content.summaryArgumentCount = 40
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("scheduling notification with id:\(notification.id)")
            }
        }
    }
}
