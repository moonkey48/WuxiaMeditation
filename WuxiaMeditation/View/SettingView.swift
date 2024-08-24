//
//  SettingView.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 6/18/24.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var observable = SettingObservable()
    
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
                        if observable.isEditMode {
                            DatePicker("첫번째 운기조식", selection: $observable.firstTime, displayedComponents: [.hourAndMinute])
                            DatePicker("두번째 운기조식", selection: $observable.secondTime, displayedComponents: [.hourAndMinute])
                            DatePicker("세번째 운기조식", selection: $observable.thirdTime, displayedComponents: [.hourAndMinute])
                        } else {
                            HStack {
                                Text("첫번째 운기조식")
                                Spacer()
                                Text(observable.firstTime.hourAndMinute)
                            }
                            HStack {
                                Text("두번째 운기조식")
                                Spacer()
                                Text(observable.secondTime.hourAndMinute)
                            }
                            HStack {
                                Text("세번째 운기조식")
                                Spacer()
                                Text(observable.thirdTime.hourAndMinute)
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
                                Text(observable.breathSpeed.breathSpeedDescription)
                                    .animation(.easeInOut, value: observable.breathSpeed)
                                
                            }
                            Slider(value: $observable.breathSpeed, in: 1...5, step: 1)
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
                                Toggle(isOn: $observable.isHapticOn, label: {
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
                        observable.isMusicSelect = true
                    } label: {
                        HStack(spacing: 24) {
                            Text("배경음악")
                                .font(.customTitle3Bold)
                            Spacer()
                            Text(observable.selectedMusic)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white.opacity(0.3))
                        )
                    }
                    Button {
                        observable.isShowWuxiaInfo = true
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
                if observable.isEditMode {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            observable.setDateFromUserDefaults()
                            observable.isEditMode.toggle()
                        } label: {
                            Text("취소")
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if observable.isEditMode {
                            observable.setUserDefaultsFromDates()
                        }
                        observable.isEditMode.toggle()
                    } label: {
                        if observable.isEditMode {
                            Text("저장")
                        } else {
                            Text("수정")
                        }
                    }
                }
            }
            .padding()
            .sheet(isPresented: $observable.isShowWuxiaInfo) {
                WuxiaInfoView(isShowWuxiaInfo: $observable.isShowWuxiaInfo)
            }
            .sheet(isPresented: $observable.isMusicSelect) {
                SelectMusicModalView()
            }
            .onAppear {
                observable.setDateFromUserDefaults()
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingView()
    }
}
