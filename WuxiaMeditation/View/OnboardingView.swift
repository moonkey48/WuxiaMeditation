//
//  OnboardingView.swift
//  WuxiaMeditation
//
//  Created by Austin's Macbook Pro M3 on 6/15/24.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("isOnboarding") private var isOnboarding: Bool = true
    @State private var isShowChangeNotificationDate = false
    
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
                withAnimation {
                    // set notification
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
            NotificationSelectDateView { firstTime, secondTime, thirdTime in
                NotificationRequest.setNotifications(times: [firstTime, secondTime, thirdTime])
                isShowChangeNotificationDate.toggle()
            }
            .presentationDetents([.medium])
        }
    }
}

#Preview {
    OnboardingView()
}
