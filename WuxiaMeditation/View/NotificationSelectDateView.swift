//
//  NotificationSelectDateView.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 6/17/24.
//

import SwiftUI

struct NotificationSelectDateView: View {
    @State private var firstTime = Date()
    @State private var secondTime = Date()
    @State private var thirdTime = Date()
    var completion: ((_ firstTime: Date, _ secondTime: Date, _ thirdTime: Date) -> Void)
    
    var body: some View {
        VStack(spacing: 30) {
            DatePicker("첫번째 운기조식", selection: $firstTime, displayedComponents: [.hourAndMinute])
            DatePicker("두번째 운기조식", selection: $secondTime, displayedComponents: [.hourAndMinute])
            DatePicker("세번째 운기조식", selection: $thirdTime, displayedComponents: [.hourAndMinute])
            Spacer()
            LargeButtonView(title: "완료") {
                completion(firstTime, secondTime, thirdTime)
            }
        }
        .font(.customTitle3)
        .foregroundStyle(.white)
        .colorScheme(.dark)
        .background(
            Image(.background)
        )
        .padding()
    }
}



#Preview {
    NotificationSelectDateView { f, s, l in
        
    }
}
