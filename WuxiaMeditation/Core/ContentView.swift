//
//  ContentView.swift
//  WuxiaMeditation
//
//  Created by Austin's Macbook Pro M3 on 6/15/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isOnboarding") private var isOnboarding: Bool = true
    
    var body: some View {
        if isOnboarding {
            OnboardingView()
        } else {
            MainView()
        }
    }
}

#Preview {
    ContentView()
}
