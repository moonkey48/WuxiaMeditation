//
//  Tab.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 8/25/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("운기조식", systemImage: "aqi.medium")
                }
            SettingView()
                .tabItem {
                    Label("설정", systemImage: "person.and.background.striped.horizontal")
                }
        }
    }
}

#Preview {
    MainTabView()
}
