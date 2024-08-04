//
//  NotificationSelectDateView.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 6/17/24.
//

import SwiftUI

struct NotificationSelectDateView: View {
    @Binding var dateList: [Date]
    @Binding var isShowChangeNotificationDate: Bool
    
    private func meditationIndexDescription(_ index: Int) -> String {
        if index == 0 { return "첫번째" }
        else if index == 1 { return "두번째" }
        else if index == 2 { return "세번째" }
        return ""
    }
    
    var body: some View {
        VStack(spacing: 30) {
            ForEach(dateList.indices, id: \.self) { index in
                DatePicker("\(meditationIndexDescription(index)) 운기조식", selection: $dateList[index], displayedComponents: [.hourAndMinute])
            }
            Spacer()
            LargeButtonView(title: "완료") {
                isShowChangeNotificationDate = false
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
    NotificationSelectDateView(dateList: .constant([]), isShowChangeNotificationDate: .constant(true))
}
