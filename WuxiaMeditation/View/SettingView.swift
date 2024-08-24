//
//  SettingView.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 6/18/24.
//

import SwiftUI

struct SettingView: View {
    @AppStorage("firstTimeString") var firstTimeString: String = "07:30"
    @AppStorage("secondTimeString") var secondTimeString: String = "18:00"
    @AppStorage("thirdTimeString") var thirdTimeString: String = "23:00"
    
    @AppStorage("breathSpeed") var breathSpeed: Double = 3
    @AppStorage("isHapticOn") var isHapticOn: Bool = true
    @AppStorage("selectedMusic") var selectedMusic: String = "Somnolent_TheTides"
    
    @State private var isEditMode = false
    @State private var firstTime = Date()
    @State private var secondTime = Date()
    @State private var thirdTime = Date()
    
    @State private var isShowWuxiaInfo = false
    @State private var isMusicSelect = false
    
    var body: some View {
        ZStack {
            DefaultBackgroundAnimationView()
            VStack {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading,spacing: 24) {
                        HStack {
                            Text("운기조식 알람 시간")
                                .font(.customTitle3Bold)
                            Spacer()
                            Image(systemName: "person.and.background.dotted")
                        }
                        Divider()
                        if isEditMode {
                            DatePicker("첫번째 운기조식", selection: $firstTime, displayedComponents: [.hourAndMinute])
                            DatePicker("두번째 운기조식", selection: $secondTime, displayedComponents: [.hourAndMinute])
                            DatePicker("세번째 운기조식", selection: $thirdTime, displayedComponents: [.hourAndMinute])
                        } else {
                            HStack {
                                Text("첫번째 운기조식")
                                Spacer()
                                Text(firstTime.hourAndMinute)
                            }
                            HStack {
                                Text("두번째 운기조식")
                                Spacer()
                                Text(secondTime.hourAndMinute)
                            }
                            HStack {
                                Text("세번째 운기조식")
                                Spacer()
                                Text(thirdTime.hourAndMinute)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white.opacity(0.3))
                    )
                    VStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("호흡 속도")
                                    .font(.customTitle3Bold)
                                Spacer()
                                Text(BreathState.getBreathSpeedDescription(breathSpeed))
                                    .animation(.easeInOut, value: breathSpeed)
                                
                            }
                            Slider(value: $breathSpeed, in: 1...5, step: 1)
                                .tint(.primaryGreen)
                        }
                        .padding()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white.opacity(0.3))
                    )
                    VStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("햅틱 사용")
                                    .font(.customTitle3Bold)
                                Spacer()
                                Toggle(isOn: $isHapticOn, label: {
                                    Text("")
                                })
                            }
                        }
                        .padding()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white.opacity(0.3))
                    )
                    Button {
                        isMusicSelect = true
                    } label: {
                        HStack(spacing: 24) {
                            Text("배경음악")
                                .font(.customTitle3Bold)
                            Spacer()
                            Text(selectedMusic)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white.opacity(0.3))
                        )
                    }
                    Button {
                        isShowWuxiaInfo = true
                    } label: {
                        HStack(spacing: 24) {
                            Text("무협입문 武俠入門")
                                .font(.customTitle3Bold)
                            Spacer()
                            Image(systemName: "ipad.and.arrow.forward")
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white.opacity(0.3))
                        )
                    }
                }
                .foregroundStyle(.primaryGreen)
                Spacer()
            }
            .font(.customTitle3)
            .foregroundStyle(.white)
            .colorScheme(.dark)
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
            .sheet(isPresented: $isShowWuxiaInfo) {
                WuxiaInfoView(isShowWuxiaInfo: $isShowWuxiaInfo)
            }
            .sheet(isPresented: $isMusicSelect) {
                SelectMusicModalView()
            }
            .onAppear {
                setDateFromUserDefaults()
            }
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
        NotificationManager.sendNotification(dateList: [firstTime, secondTime, thirdTime])
    }
}

#Preview {
    NavigationStack {
        SettingView()
    }
}
