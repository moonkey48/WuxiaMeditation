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
        Group {
            if isOnboarding {
                OnboardingView()
            } else {
                MainTabView()
            }
        }
        .tint(.primaryGreen)
        .onAppear {
            if isOnboarding {
                UserDefaults.standard.setValue(3, forKey: "breathSpeed")
                UserDefaults.standard.setValue(true, forKey: "isHapticOn")
                UserDefaults.standard.setValue("Somnolent_TheTides", forKey: "selectedMusic")
            }
        }
    }
}

#Preview {
    ContentView()
}
