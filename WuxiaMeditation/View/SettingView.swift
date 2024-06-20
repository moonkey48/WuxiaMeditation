//
//  SettingView.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 6/18/24.
//

import SwiftUI

struct SettingView: View {
    @State private var isEditMode = false
    @State private var firstTime = Date()
    @State private var secondTime = Date()
    @State private var thirdTime = Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("운기조식 알람 시간")
                .font(.customTitle)
                .padding(.vertical, 24)
            DatePicker("첫번째 운기조식", selection: $firstTime, displayedComponents: [.hourAndMinute])
            DatePicker("두번째 운기조식", selection: $secondTime, displayedComponents: [.hourAndMinute])
            DatePicker("세번째 운기조식", selection: $thirdTime, displayedComponents: [.hourAndMinute])
            Spacer()
        }
        .font(.customTitle3)
        .foregroundStyle(.white)
        .colorScheme(.dark)
        .background(
            Image(.background)
                .ignoresSafeArea()
        )
        .toolbar {
            Button {
                isEditMode.toggle()
            } label: {
                if isEditMode {
                    Text("저장")
                } else {
                    Text("수정")
                }
            }
        }
        .padding()
        .tint(.white)
    }
}

#Preview {
    NavigationStack {
        SettingView()
    }
}
