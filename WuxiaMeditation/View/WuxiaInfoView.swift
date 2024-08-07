//
//  WuxiaInfoView.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 8/7/24.
//

import SwiftUI

struct WuxiaInfo: Identifiable {
    let id = UUID()
    var title: String
    var infoList: [WuxiaSubInfo]
}

struct WuxiaSubInfo: Identifiable {
    let id = UUID()
    var title: String?
    var description: [String]
}

extension WuxiaInfo {
    static let dummyInfoList: [WuxiaInfo] = [
        WuxiaInfo(title: "시 時", infoList: [
            WuxiaSubInfo(title: "자시(子時): 23:00 ~ 01:00", description: ["하루의 시작으로, 자정(午夜)을 포함합니다."]),
            WuxiaSubInfo(title: "축시(丑時): 01:00 ~ 03:00", description: ["소가 여물음을 되새김질하는 시간입니다."]),
            WuxiaSubInfo(title: "인시(寅時): 03:00 ~ 05:00", description: ["호랑이가 활동하기 시작하는 시간입니다."]),
            WuxiaSubInfo(title: "묘시(卯時): 05:00 ~ 07:00", description: ["토끼가 뛸 수 있는 새벽의 시간입니다. 이 시간대에는 해가 떠오르기 시작합니다."]),
            WuxiaSubInfo(title: "진시(辰時): 07:00 ~ 09:00", description: ["용이 하늘로 올라간다고 표현되는 아침 시간입니다."]),
            WuxiaSubInfo(title: "사시(巳時): 09:00 ~ 11:00", description: ["뱀이 활동하는 시간으로, 해가 중천에 떠 있는 시간대입니다."]),
            WuxiaSubInfo(title: "오시(午時): 11:00 ~ 13:00", description: ["말이 힘차게 달리는 정오의 시간입니다."]),
            WuxiaSubInfo(title: "미시(未時): 13:00 ~ 15:00", description: ["양이 풀을 뜯는 오후의 시간대입니다."]),
            WuxiaSubInfo(title: "신시(申時): 15:00 ~ 17:00", description: ["원숭이가 활발히 움직이는 시간으로, 오후 늦은 시간입니다."]),
            WuxiaSubInfo(title: "유시(酉時): 17:00 ~ 19:00", description: ["닭이 집으로 돌아오는 저녁 시간입니다."]),
            WuxiaSubInfo(title: "술시(戌時): 19:00 ~ 21:00", description: ["개가 밤을 지키기 위해 움직이는 시간입니다."]),
            WuxiaSubInfo(title: "해시(亥時): 21:00 ~ 23:00", description: ["돼지가 잠을 자는 밤의 시간대로, 하루의 끝을 의미합니다."]),
        ]),
        WuxiaInfo(title: "소주천과 대주천 小周天 大周天", infoList: [
            WuxiaSubInfo(title: "소주천 (小周天)", description: [
                "(운기조식 앱에서는 1분 내외의 시간동안 운기조식하는 것으로 사용됩니다.)",
                "소주천은 작은 순환을 뜻하며, 주로 인체의 두 가지 주요 경락인 임맥(任脈)과 독맥(督脈)을 따라 기가 순환하는 것을 말합니다.",
            ]),
            WuxiaSubInfo(title: "대주천 (大周天)", description: [
                "(운기조식 앱에서는 10분 내외의 시간동안 운기조식하는 것으로 사용됩니다.)",
                "대주천은 큰 순환을 뜻하며, 소주천보다 더 넓은 범위의 경락을 따라 기가 순환하는 것을 의미합니다. 대주천은 소주천에서 다루지 않는 12경락(十二經絡) 전체를 포함하며, 이는 인체 전체를 아우르는 더 복잡하고 깊은 기의 순환을 뜻합니다.",
            ]),
        ]),
        WuxiaInfo(title: "단전", infoList: [
            WuxiaSubInfo(description: [
                "(운기조식 앱에서는 마음의 상태, 안정도에 대한 의미로 사용됩니다.)",
                "단전(丹田)은 전통적인 동양 철학, 특히 도교와 기공 수련에서 매우 중요한 개념으로, 인체에 존재하는 세 개의 주요 에너지 센터를 가리킵니다. ",
                "이 단전은 기(氣)가 모이고 축적되는 곳으로 여겨지며, 신체와 정신의 균형을 유지하고 에너지를 조절하는 데 중요한 역할을 합니다.",
            ]),
        ]),
    ]
}


struct WuxiaInfoView: View {
    var body: some View {
        ZStack {
            DefaultBackgroundAnimationView()
                .ignoresSafeArea()
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .background(.ultraThinMaterial.opacity(0.4))
            ScrollView {
                VStack(alignment: .leading, spacing: 80){
                    Spacer()
                        .frame(height: 100)
                    HStack {
                        Spacer()
                        VStack(spacing: 24) {
                            Text("運氣調息")
                                .font(.system(size: 80))
                            VStack(alignment: .leading, spacing: 8) {
                                Text("운기조식(運氣調息)은 기(氣)의 흐름을 조절하고 마음을 다스리는 명상입니다.")
                                    .multilineTextAlignment(.center)
                            }
                            .font(.customBody)
                        }
                        Spacer()
                    }
                    ForEach(WuxiaInfo.dummyInfoList) { info in
                        VStack(alignment: .leading, spacing: 26) {
                            Text(info.title)
                                .font(.customTitle3Bold)
                            ForEach(info.infoList) { subInfo in
                                VStack(alignment: .leading, spacing: 8) {
                                    if let subTitle = subInfo.title {
                                        Text(subTitle)
                                    }
                                    VStack(alignment: .leading, spacing: 20) {
                                        ForEach(subInfo.description, id: \.self) { desciption in
                                            Text(desciption)
                                        }
                                    }
                                    .opacity(0.7)
                                }
                            }
                        }
                        .font(.customBody)
                        
                    }
                }
                .padding()
                .foregroundStyle(.white)
                .lineSpacing(8)
            }
        }
    }
}


 
#Preview {
    WuxiaInfoView()
}
