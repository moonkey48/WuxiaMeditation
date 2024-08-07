//
//  WuxiaInfoView.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 8/7/24.
//

import SwiftUI

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
