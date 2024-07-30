//
//  DefaultBackgroundAnimationView.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 7/30/24.
//

import SwiftUI

struct DefaultBackgroundAnimationView: View {
    @State private var animationTime: Float = 0
    @State private var staticTime: Float = 0
    var body: some View {
        Rectangle()
            .fill(.circleMotionWithBackground(time: animationTime, secondTime: staticTime))
            .ignoresSafeArea()
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                    self.animationTime += 0.1
                }
            }
    }
}

#Preview {
    DefaultBackgroundAnimationView()
}
