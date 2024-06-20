//
//  OnboardingView.swift
//  WuxiaMeditation
//
//  Created by Austin's Macbook Pro M3 on 6/15/24.
//

import SwiftUI


struct OnboardingView: View {
    @AppStorage("isOnboarding") private var isOnboarding: Bool = true
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var isShowChangeNotificationDate = false
    @State private var dateList: [Date] = []
    @AppStorage("firstTimeString") var firstTimeString: String = "07:30"
    @AppStorage("secondTimeString") var secondTimeString: String = "18:00"
    @AppStorage("thirdTimeString") var thirdTimeString: String = "23:00"
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text("運氣調息")
                .foregroundStyle(.white)
                .font(.system(size: 34))
                .padding(.bottom, 16)
            Text("일과 삶의 마음 지킴 명상앱\n운기조식運氣調息")
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .font(.customBody)
                .lineSpacing(6)
            Spacer()
            VStack(spacing: 10) {
                Text("아침, 저녁, 밤에 운기조식 알람을 보내드립니다.")
                Button {
                    isShowChangeNotificationDate.toggle()
                } label: {
                    Text("일정 변경")
                        .opacity(0.7)
                }
            }
            .font(.customCaption)
            .foregroundStyle(.white)
            .padding(.bottom, 30)
            
            LargeButtonView(title: "시작") {
                notificationManager.sendNotification(dateList: dateList)
                for date in dateList {
                    print(date.hourAndMinute)
                }
                withAnimation {
                    isOnboarding = false
                }
            }
        }
        .background(
            Image(.background)
                .ignoresSafeArea(edges: .top)
        )
        .padding(16)
        .sheet(isPresented: $isShowChangeNotificationDate) {
            NotificationSelectDateView(dateList: $dateList, isShowChangeNotificationDate: $isShowChangeNotificationDate)
            .presentationDetents([.medium])
        }
        .onAppear {
            setDateFromUserDefaults()
        }
    }
    
    func setDateFromUserDefaults() {
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "HH:mm"
        var newDateList: [Date] = []
        if let firstTime = dateFormmater.date(from: firstTimeString) {
            newDateList.append(firstTime)
        }
        if let secondTime = dateFormmater.date(from: secondTimeString) {
            newDateList.append(secondTime)
        }
        if let thirdTime = dateFormmater.date(from: thirdTimeString) {
            newDateList.append(thirdTime)
        }
        dateList = newDateList
    }
}

#Preview {
    OnboardingView()
}
