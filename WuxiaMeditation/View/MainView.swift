//
//  EnergyCenterView.swift
//  WuxiaMeditation
//
//  Created by Austin's Macbook Pro M3 on 6/15/24.
//

import SwiftUI

struct MainView: View {
    @State private var observable: MeditationObservable = MeditationObservable()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(.circleMotionWithBackground(timeForRotating: observable.timeForRotating, timeForScale: observable.timeForScale))
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Image(systemName: "aqi.medium")
                            .imageScale(.large)
                            .foregroundStyle(.clear)
                        Spacer()
                        Text("運氣調息")
                            .font(.title3)
                        Spacer()
                        NavigationLink {
                            SettingView()
                        } label: {
                            Image(systemName: "aqi.medium")
                                .imageScale(.large)
                        }
                    }
                    .foregroundStyle(.primaryGreen)
                    Spacer()
                    switch observable.meditationState {
                    case .notStarted: EnergyCenterView(observable: observable)
                    case .progressing: MeditationView(observable: observable)
                    default: HStack { Spacer() }
                    }
                }
                .padding()
                .onAppear {
                    observable.checkWuxiaTimeChanged()
                }
                
            }
        }
        .tint(.primaryGreen)
    }
}

struct EnergyCenterView: View {
    var observable: MeditationObservable
    
    var body: some View {
        Text(observable.isMeditationDoneOnTime ? observable.currentWuxiaTime.titleDescriptionAfterMeditation : observable.currentWuxiaTime.titleDescriptionBeforeMeditation)
            .font(.customTitle)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .lineSpacing(6.0)
        Spacer()
        Text(observable.energyState.description)
            .font(.customBody)
            .foregroundStyle(.primaryGreen)
            .multilineTextAlignment(.center)
            .lineSpacing(4.0)
            .padding(.bottom, 40)
        HStack {
            LargeButtonView(title: "소주천 小周天", meditationRange: .smallMeditation) {
                observable.setMeditationStarted(.smallMeditation)
            }
            LargeButtonView(title: "대주천 大周天", meditationRange: .bigMeditation) {
                observable.setMeditationStarted(.bigMeditation)
            }
        }
    }
}

struct MeditationView: View {
    @Bindable var observable: MeditationObservable
    
    var body: some View {
        Spacer()
        Spacer()
        VStack {
            if let desciription = observable.breathStateDescription?.wuxiaDescription {
                Text(desciription)
                    .font(.customTitle3)
                    .foregroundStyle(.white)
            }
        }
        .animation(.easeInOut(duration: 1), value: observable.breathStateDescription?.wuxiaDescription)
        Spacer()
        Spacer()
        VStack(spacing: 10) {
            Text(observable.meditationSentence.sentence)
                .font(.customTitle3)
                .lineSpacing(1.0)
            Text(observable.meditationSentence.author)
                .font(.customCaption)
        }
        .foregroundStyle(.primaryGreen)
        .multilineTextAlignment(.center)
        .frame(height: 140)
        .padding(.bottom, 20)
        
        
        LargeButtonView(title: observable.isFinishedMeditation ? "운기조식 종료" : "\(observable.meditationTimeRemaining) 뒤 종료", color: .white.opacity(observable.isFinishedMeditation ? 1 : 0.5)) {
            observable.isShowEndMeditationAlert = true
        }
        .alert(isPresented: $observable.isShowEndMeditationAlert) {
            Alert(
                title: Text("운기조식을 종료합니다."),
                primaryButton:
                        .destructive(Text("종료"), action: {
                            observable.setMeditationEnded()
                        }),
                secondaryButton: .cancel(Text("취소")))
        }
    }
    
}
#Preview {
    MainView()
}
