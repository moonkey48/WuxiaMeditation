//
//  SettingView.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 6/18/24.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    
    @AppStorage("firstTimeString") var firstTimeString: String = "07:30"
    @AppStorage("secondTimeString") var secondTimeString: String = "18:00"
    @AppStorage("thirdTimeString") var thirdTimeString: String = "23:00"
    
    @State private var isEditMode = false
    @State private var firstTime = Date()
    @State private var secondTime = Date()
    @State private var thirdTime = Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("운기조식 알람 시간")
                .font(.customTitle)
                .padding(.vertical, 24)
            if isEditMode {
                DatePicker("첫번째 운기조식", selection: $firstTime, displayedComponents: [.hourAndMinute])
                    .frame(height: 50)
                DatePicker("두번째 운기조식", selection: $secondTime, displayedComponents: [.hourAndMinute])
                    .frame(height: 50)
                DatePicker("세번째 운기조식", selection: $thirdTime, displayedComponents: [.hourAndMinute])
                    .frame(height: 50)
            } else {
                HStack {
                    Text("첫번째 운기조식")
                    Spacer()
                    Text(firstTime.hourAndMinute)
                }
                .frame(height: 50)
                HStack {
                    Text("두번째 운기조식")
                    Spacer()
                    Text(secondTime.hourAndMinute)
                }
                .frame(height: 50)
                HStack {
                    Text("세번째 운기조식")
                    Spacer()
                    Text(thirdTime.hourAndMinute)
                }
                .frame(height: 50)
            }
            Spacer()
        }
        .font(.customTitle3)
        .foregroundStyle(.white)
        .colorScheme(.dark)
        .background(
            Image(.background)
                .ignoresSafeArea()
        )
        .toolbar {
            if isEditMode {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        setDateFromUserDefaults()
                        isEditMode.toggle()
                    } label: {
                        Text("취소")
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if isEditMode {
                        setUserDefaultsFromDates()
                    }
                    isEditMode.toggle()
                } label: {
                    if isEditMode {
                        Text("저장")
                    } else {
                        Text("수정")
                    }
                }
            }
        }
        .padding()
        .onAppear {
            setDateFromUserDefaults()
        }
    }
    
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
        notificationManager.reScheduleNotifications([firstTime, secondTime, thirdTime])
    }
}

#Preview {
    NavigationStack {
        SettingView()
    }
}
