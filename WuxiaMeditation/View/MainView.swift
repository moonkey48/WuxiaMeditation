//
//  EnergyCenterView.swift
//  WuxiaMeditation
//
//  Created by Austin's Macbook Pro M3 on 6/15/24.
//

import SwiftUI

struct MainView: View {
    @State private var observable: MeditationObservable = MeditationObservable()
    @State private var startTime = Date.now
    @State private var time: Float = 0
    
    var body: some View {
        NavigationStack {
            let elapsedTime = startTime.distance(to: Date.now)
            ZStack {
                PlayerView(energyState: $observable.energyState)
                    .ignoresSafeArea()
                Rectangle()
//                    .fill(.grainGradient2(time: elapsedTime))
                    .fill(.grainGradient4(time: time))
//                    .frame(width: 300, height: 300)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Spacer()
                        Text("運氣調息")
                            .font(.title3)
                            .foregroundStyle(.white)
                        Spacer()
                        NavigationLink {
                            SettingView()
                        } label: {
                            Image(systemName: "aqi.medium")
                                .foregroundStyle(.white)
                                .imageScale(.large)
                        }
                    }
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
                    DispatchQueue.global().async() {
                        guard let url = URL(string: "https://api.adviceslip.com/advice") else {
                                print("error")
                                return
                            }
                            
                            URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
                                print(data)
                            }.resume()
                    }
                }
                
            }
        }
        .tint(.primaryGreen)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                time += 0.1
            }
        }
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
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .lineSpacing(4.0)
            .padding(.bottom, 40)
        LargeButtonView(title: "운기조식 시작", energyState: observable.energyState) {
            observable.setMeditationStarted()
        }
    }
}

struct MeditationView: View {
    @Bindable var observable: MeditationObservable
    
    var body: some View {
        VStack(spacing: 20) {
            Text(observable.meditationSentence.sentence)
                .font(.customTitle3)
            Text(observable.meditationSentence.author)
                .font(.customCaption)
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .lineSpacing(6.0)
        
        Spacer()
        Text("일다경동안 운기조식을 합니다.")
            .font(.customBody)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .lineSpacing(4.0)
            .padding(.bottom, 40)
        LargeButtonView(title: observable.isFinishedMeditation ? "운기조식 종료" : "\(observable.meditationTimeRemaining) 뒤 종료", color: .white.opacity(observable.isFinishedMeditation ? 1 : 0.5), energyState: observable.energyState) {
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
