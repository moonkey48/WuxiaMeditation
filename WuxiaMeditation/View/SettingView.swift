//
//  SettingView.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 6/18/24.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var settingObservable = SettingObservable()
    
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
                        if settingObservable.isEditMode {
                            DatePicker("첫번째 운기조식", selection: $settingObservable.firstTime, displayedComponents: [.hourAndMinute])
                            DatePicker("두번째 운기조식", selection: $settingObservable.secondTime, displayedComponents: [.hourAndMinute])
                            DatePicker("세번째 운기조식", selection: $settingObservable.thirdTime, displayedComponents: [.hourAndMinute])
                        } else {
                            HStack {
                                Text("첫번째 운기조식")
                                Spacer()
                                Text(settingObservable.firstTime.hourAndMinute)
                            }
                            HStack {
                                Text("두번째 운기조식")
                                Spacer()
                                Text(settingObservable.secondTime.hourAndMinute)
                            }
                            HStack {
                                Text("세번째 운기조식")
                                Spacer()
                                Text(settingObservable.thirdTime.hourAndMinute)
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
                                Text(BreathState.getBreathSpeedDescription(settingObservable.breathSpeed))
                                    .animation(.easeInOut, value: settingObservable.breathSpeed)
                                
                            }
                            Slider(value: $settingObservable.breathSpeed, in: 1...5, step: 1)
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
                                Toggle(isOn: $settingObservable.isHapticOn, label: {
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
                        settingObservable.isMusicSelect = true
                    } label: {
                        HStack(spacing: 24) {
                            Text("배경음악")
                                .font(.customTitle3Bold)
                            Spacer()
                            Text(settingObservable.selectedMusic)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white.opacity(0.3))
                        )
                    }
                    Button {
                        settingObservable.isShowWuxiaInfo = true
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
                if settingObservable.isEditMode {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            setDateFromUserDefaults()
                            settingObservable.isEditMode.toggle()
                        } label: {
                            Text("취소")
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if settingObservable.isEditMode {
                            setUserDefaultsFromDates()
                        }
                        settingObservable.isEditMode.toggle()
                    } label: {
                        if settingObservable.isEditMode {
                            Text("저장")
                        } else {
                            Text("수정")
                        }
                    }
                }
            }
            .padding()
            .sheet(isPresented: $settingObservable.isShowWuxiaInfo) {
                WuxiaInfoView(isShowWuxiaInfo: $settingObservable.isShowWuxiaInfo)
            }
            .sheet(isPresented: $settingObservable.isMusicSelect) {
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
        if let firstDate = dateFormmater.date(from: settingObservable.firstTimeString) {
            settingObservable.firstTime = firstDate
        }
        if let secondDate = dateFormmater.date(from: settingObservable.secondTimeString) {
            settingObservable.secondTime = secondDate
        }
        if let thirdDate = dateFormmater.date(from: settingObservable.thirdTimeString) {
            settingObservable.thirdTime = thirdDate
        }
    }
    
    func setUserDefaultsFromDates() {
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "HH:mm"
        settingObservable.firstTimeString = dateFormmater.string(from: settingObservable.firstTime)
        settingObservable.secondTimeString = dateFormmater.string(from: settingObservable.secondTime)
        settingObservable.thirdTimeString = dateFormmater.string(from: settingObservable.thirdTime)
        NotificationManager().sendNotification(dateList: [settingObservable.firstTime, settingObservable.secondTime, settingObservable.thirdTime])
    }
}

#Preview {
    NavigationStack {
        SettingView()
    }
}
