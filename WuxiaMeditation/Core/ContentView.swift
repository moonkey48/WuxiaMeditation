//
//  ContentView.swift
//  WuxiaMeditation
//
//  Created by Austin's Macbook Pro M3 on 6/15/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var notificationManager = NotificationManager()
    @AppStorage("isOnboarding") private var isOnboarding: Bool = true
    
    init() {
        UserDefaults.standard.setValue(3, forKey: "breathSpeed")
        UserDefaults.standard.setValue(true, forKey: "isHapticOn")
    }
    
    var body: some View {
        Group {
            if isOnboarding {
                OnboardingView()
            } else {
                MainView()
            }
        }
        .environmentObject(notificationManager)
    }
}

#Preview {
    ContentView()
}
