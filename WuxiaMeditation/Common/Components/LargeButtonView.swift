//
//  LargeButtonView.swift
//  WuxiaMeditation
//
//  Created by Austin's Macbook Pro M3 on 6/15/24.
//

import SwiftUI

struct LargeButtonView: View {
    var title: String
    var color: Color = .white
    var meditationRange: MeditationRange = .smallMeditation
    var completion: () -> Void
    
    var body: some View {
        Button {
            completion()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12.0)
                    .fill(meditationRange == .smallMeditation ? .primaryGreen : .secondaryGreen)
                    .frame(width: .infinity, height: 50)
                Text(title)
                    .font(.customBody)
                    .foregroundStyle(color)
            }
        }
    }
}

#Preview {
    LargeButtonView(title: "시작") {
        print("start")
    }
}
