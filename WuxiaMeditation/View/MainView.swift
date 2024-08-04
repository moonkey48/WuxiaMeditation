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
                
                if case .progressing = observable.meditationState {
                    alertView
                }
                
            }
            .onAppear {
                observable.checkWuxiaTimeChanged()
            }
        }
        .tint(.primaryGreen)
    }
}

private extension MainView {
    var alertView: some View {
        Group {
            VStack(spacing: 10) {
                Text("운기조식을 마무리합니다.")
                    .font(.customTitle3)
                Text("마지막으로 눈을 감고,\n생각을 갈무리 하신 뒤 종료하십시오.")
                    .foregroundStyle(.black.opacity(0.6))
                    .padding(.bottom, 20)
                    
                HStack {
                    Button {
                        withAnimation {
                            observable.isShowEndMeditationAlert = false
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("취소")
                                .foregroundStyle(.primaryRed)
                            Spacer()
                        }
                    }
                    Button {
                        observable.setMeditationEnded()
                    } label: {
                        HStack {
                            Spacer()
                            Text("종료")
                                .foregroundStyle(.primaryGreen)
                            Spacer()
                        }
                    }
                }
            }
            .padding(20)
            .font(.customBody)
            .multilineTextAlignment(.center)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial.opacity(0.9))
            )
        }
        .padding(.horizontal, 30)
        .opacity(observable.isShowEndMeditationAlert ? 1 : 0)
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
            withAnimation {
                observable.isShowEndMeditationAlert = true
            }
        }
    }
    
}
#Preview {
    MainView()
}
