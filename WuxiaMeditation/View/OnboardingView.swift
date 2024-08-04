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
    @State private var isStart = false
    @AppStorage("firstTimeString") var firstTimeString: String = "07:30"
    @AppStorage("secondTimeString") var secondTimeString: String = "18:00"
    @AppStorage("thirdTimeString") var thirdTimeString: String = "23:00"
    
    var body: some View {
        VStack(spacing: 0) {
            if isStart {
                Spacer()
                HStack {
                    Spacer()
                    Text("\(dummyMeditationSentenceList.randomElement()?.sentence ?? dummyMeditationSentenceList[0].sentence)")
                        .font(.customTitle3)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6.0)
                    Spacer()
                }
                .padding(.bottom, 40)
                
                Text("入門中")
                    .font(.customTitle3)
                    .foregroundStyle(.white)
                    .padding(.bottom, 16)
                ProgressView()
                    .tint(.white)
                Spacer()
            } else {
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
                .foregroundStyle(.primaryGreen)
                .padding(.bottom, 30)
                
                LargeButtonView(title: "시작") {
                    notificationManager.sendNotification(dateList: dateList)
                    withAnimation {
                        isStart = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            isOnboarding = false
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(
            DefaultBackgroundAnimationView()
        )
        .sheet(isPresented: $isShowChangeNotificationDate) {
            NotificationSelectDateView(dateList: $dateList, isShowChangeNotificationDate: $isShowChangeNotificationDate)
            .presentationDetents([.medium])
        }
        .onAppear {
            setDateFromUserDefaults()
        }
    }
}

/// handle notifications
extension OnboardingView {
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
    
    func setUserDefaultsFromDates() {
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "HH:mm"
        firstTimeString = dateFormmater.string(from: dateList[0])
        secondTimeString = dateFormmater.string(from: dateList[1])
        thirdTimeString = dateFormmater.string(from: dateList[2])
    }
}


#Preview {
    OnboardingView()
}
